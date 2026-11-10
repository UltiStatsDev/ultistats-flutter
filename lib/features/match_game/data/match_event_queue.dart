import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ultistats/core/logging/app_logger.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/domain/repositories/match_events_repository.dart';

/// Последовательная отправка событий матча на сервер.
///
/// События одного матча уходят строго по одному и в порядке постановки в
/// очередь: следующий запрос стартует только после завершения предыдущего,
/// поэтому ответы не могут обогнать друг друга.
///
/// Отмена последнего события ставится в ту же очередь: на сервер она уходит
/// после всех уже поставленных событий, поэтому удаляется именно последнее из
/// них.
///
/// Очередь живёт в провайдере уровня приложения, поэтому переживает
/// пересоздание notifier-а экрана матча.
class MatchEventQueue {
  MatchEventQueue(
    this._repository, {
    int maxAttempts = 3,
    List<Duration> retryDelays = const [
      Duration(milliseconds: 300),
      Duration(seconds: 1),
      Duration(seconds: 3),
    ],
  }) : _maxAttempts = maxAttempts,
       _retryDelays = retryDelays;

  final MatchEventsRepository _repository;

  final int _maxAttempts;
  final List<Duration> _retryDelays;

  /// Хвост очереди для каждого матча: разные матчи не блокируют друг друга.
  final Map<String, Future<void>> _tails = {};

  /// Ставит событие в очередь. Запрос уйдёт после всех предыдущих событий
  /// этого матча.
  ///
  /// Возвращает `true`, если событие в итоге ушло на сервер, и `false`, если
  /// все попытки провалились. Это позволяет отмене понять, можно ли откатывать
  /// событие на сервере.
  Future<bool> enqueue(String matchId, Event event) {
    log(
      'Enqueued ${event.type.name} event of match $matchId',
      name: 'MatchEventQueue',
      level: AppLogLevel.debug,
    );

    return _enqueue(matchId, () => _sendWithRetry(matchId, event));
  }

  /// Ставит в очередь удаление последнего события матча.
  ///
  /// Запрос уйдёт после всех уже поставленных событий этого матча, поэтому на
  /// сервере удалится именно последнее из них.
  ///
  /// Повторов нет: v1 undo не идемпотентен, и повтор после потерянного ответа
  /// удалил бы ещё одно событие. Возвращает `true`, если событие удалено.
  Future<bool> enqueueUndo(String matchId) {
    log(
      'Enqueued undo of last event of match $matchId',
      name: 'MatchEventQueue',
      level: AppLogLevel.debug,
    );

    return _enqueue(matchId, () => _undo(matchId));
  }

  /// Добавляет задачу в хвост очереди матча и возвращает её результат.
  ///
  /// Хвост не пробрасывает ошибки задачи дальше: иначе одна неудачная задача
  /// навсегда заблокировала бы все следующие.
  Future<bool> _enqueue(String matchId, Future<bool> Function() task) {
    final previous = _tails[matchId] ?? Future<void>.value();

    final result = previous.then((_) => task());

    late final Future<void> tail;
    tail = result
        .then<void>((_) {}, onError: (Object _, StackTrace __) {})
        .whenComplete(() {
          if (identical(_tails[matchId], tail)) {
            _tails.remove(matchId);
          }
        });

    _tails[matchId] = tail;
    return result;
  }

  /// Завершается, когда все события матча отправлены (или окончательно
  /// провалились).
  ///
  /// Нужен перед завершением матча: иначе сервер посчитает статистику раньше,
  /// чем до него дойдут последние события.
  Future<void> drain(String matchId) async {
    Future<void>? tail;
    do {
      tail = _tails[matchId];
      await tail;
    } while (!identical(tail, _tails[matchId]));
  }

  Future<bool> _sendWithRetry(String matchId, Event event) async {
    final params = CreateEventParams(matchId: matchId, event: event);

    for (var attempt = 0; attempt < _maxAttempts; attempt++) {
      try {
        await _repository.addEvent(params);
        log(
          'Sent ${event.type.name} event of match $matchId '
          '(attempt ${attempt + 1})',
          name: 'MatchEventQueue',
          level: AppLogLevel.debug,
        );
        return true;
      } catch (error, stackTrace) {
        final isLastAttempt = attempt == _maxAttempts - 1;
        if (isLastAttempt || !_isRetryable(error)) {
          log(
            'Failed to send ${event.type} event of match $matchId',
            error: error,
            stackTrace: stackTrace,
            name: 'MatchEventQueue',
          );
          return false;
        }

        log(
          'Retrying ${event.type.name} event of match $matchId '
          '(attempt ${attempt + 1} failed): $error',
          name: 'MatchEventQueue',
          level: AppLogLevel.warning,
        );
        await Future<void>.delayed(_retryDelays[attempt]);
      }
    }

    return false;
  }

  Future<bool> _undo(String matchId) async {
    try {
      await _repository.undoLastEvent(matchId);
      log(
        'Undid last event of match $matchId',
        name: 'MatchEventQueue',
        level: AppLogLevel.debug,
      );
      return true;
    } catch (error, stackTrace) {
      log(
        'Failed to undo last event of match $matchId',
        error: error,
        stackTrace: stackTrace,
        name: 'MatchEventQueue',
      );
      return false;
    }
  }

  /// Сетевые ошибки и 5xx/429 имеет смысл повторять. Остальные 4xx — нет:
  /// повторный запрос не станет валидным.
  bool _isRetryable(Object error) {
    if (error is! DioException) return true;

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError ||
      DioExceptionType.unknown => true,
      DioExceptionType.badResponse =>
        error.response?.statusCode == 429 ||
            (error.response?.statusCode ?? 0) >= 500,
      DioExceptionType.cancel || DioExceptionType.badCertificate => false,
    };
  }
}
