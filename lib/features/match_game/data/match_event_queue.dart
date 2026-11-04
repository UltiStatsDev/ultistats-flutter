import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/domain/repositories/match_events_repository.dart';

/// Последовательная отправка событий матча на сервер.
///
/// События одного матча уходят строго по одному и в порядке постановки в
/// очередь: следующий запрос стартует только после завершения предыдущего,
/// поэтому ответы не могут обогнать друг друга.
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
  void enqueue(String matchId, Event event) {
    final previous = _tails[matchId] ?? Future<void>.value();

    final task = previous.then((_) => _sendWithRetry(matchId, event));

    late final Future<void> tail;
    tail = task.whenComplete(() {
      if (identical(_tails[matchId], tail)) {
        _tails.remove(matchId);
      }
    });

    _tails[matchId] = tail;
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

  Future<void> _sendWithRetry(String matchId, Event event) async {
    final params = CreateEventParams(matchId: matchId, event: event);

    for (var attempt = 0; attempt < _maxAttempts; attempt++) {
      try {
        await _repository.addEvent(params);
        return;
      } catch (error, stackTrace) {
        final isLastAttempt = attempt == _maxAttempts - 1;
        if (isLastAttempt || !_isRetryable(error)) {
          log(
            'Failed to send ${event.type} event of match $matchId',
            error: error,
            stackTrace: stackTrace,
            name: 'MatchEventQueue',
          );
          return;
        }

        await Future<void>.delayed(_retryDelays[attempt]);
      }
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
