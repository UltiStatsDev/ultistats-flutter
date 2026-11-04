import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/logging/app_logger.dart';
import 'package:ultistats/features/match_game/domain/match_action.dart';
import 'package:ultistats/features/match_game/domain/match_game_engine.dart';
import 'package:ultistats/features/match_game/domain/match_game_state.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail/match_detail_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_list/matches_list_notifier.dart';

import 'match_timer_notifier.dart';

part 'match_game_notifier.g.dart';

@riverpod
class MatchGameNotifier extends _$MatchGameNotifier {
  static const _engine = MatchGameEngine();

  /// Точка отмены: состояние до последнего действия и результат отправки его
  /// события. `sent == null`, если действие не создавало событий.
  ///
  /// Живёт только до одной отмены.
  ({MatchGameState state, Future<bool>? sent})? _undoPoint;

  /// Пока отмена ждёт ответа сервера, новые действия запрещены: иначе событие
  /// встанет в очередь между отменяемым событием и запросом отмены, и отмена
  /// удалит уже его.
  bool _isUndoing = false;

  @override
  MatchGameState build(MatchDetail match) {
    final initialElapsed = match.startedAt != null
        ? DateTime.now().difference(match.startedAt!)
        : Duration.zero;

    Future.microtask(() {
      ref
          .read(matchTimerProvider(match.id).notifier)
          .start(initialDuration: initialElapsed);
    });

    return GameStateLineupSelection(match: match);
  }

  /// Можно ли отменить последнее действие. Отмена доступна только один раз:
  /// после успешного отката предыдущее состояние очищается.
  bool get canUndo => _undoPoint != null && !_isUndoing;

  /// Единственная точка изменения состояния игры.
  ///
  /// Перевод состояния и события для сервера вычисляет [MatchGameEngine].
  /// [UndoLastAction] движок не обрабатывает — его перехватывает нотифаер.
  void dispatch(MatchAction action) {
    if (action is UndoLastAction) {
      unawaited(undo());
      return;
    }

    if (_isUndoing) {
      log(
        "Ignoring ${action.runtimeType} while undo is in progress",
        name: runtimeType.toString(),
        level: AppLogLevel.warning,
      );
      return;
    }

    final previous = state;
    final transition = _engine.apply(state, action);

    if (transition == null) {
      log(
        "Action ${action.runtimeType} is not allowed in ${state.runtimeType} state",
        name: runtimeType.toString(),
        level: AppLogLevel.warning,
      );
      return;
    }

    log(
      "Action ${action.runtimeType} in ${state.runtimeType} -> "
      "${transition.state.runtimeType}, "
      "events: ${transition.events.map((e) => e.type.name).join(', ')}",
      name: runtimeType.toString(),
      level: AppLogLevel.debug,
    );

    state = transition.state;

    // Движок создаёт не больше одного события на действие, поэтому для
    // отмены достаточно одного undo-запроса.
    final queue = ref.read(matchEventQueueProvider);
    Future<bool>? sent;
    for (final event in transition.events) {
      sent = queue.enqueue(state.match.id, event);
    }

    // Выбор игроков состава не занимает слот отмены и не сбрасывает его:
    // после гола можно случайно переключить игрока и всё равно отменить гол.
    if (action.isUndoable) {
      _undoPoint = (state: previous, sent: sent);
    }
  }

  /// Откатывает последнее действие и, если оно создало событие, удаляет это
  /// событие на сервере.
  ///
  /// Возвращает `true`, если состояние удалось откатить.
  Future<bool> undo() async {
    final point = _undoPoint;
    if (point == null || _isUndoing) return false;

    final matchId = state.match.id;
    final queue = ref.read(matchEventQueueProvider);

    _isUndoing = true;
    _undoPoint = null;

    log(
      "Undoing ${state.runtimeType} -> ${point.state.runtimeType} "
      "for match $matchId",
      name: runtimeType.toString(),
    );

    try {
      final sent = point.sent;
      if (sent != null) {
        // Если событие не дошло до сервера, undo удалил бы предыдущее
        // (успешно отправленное) событие, поэтому откатываем только локально.
        if (await sent) {
          if (!await queue.enqueueUndo(matchId)) {
            throw StateError('Failed to undo last event of match $matchId');
          }

          log(
            "Removed last event of match $matchId",
            name: runtimeType.toString(),
          );
        } else {
          log(
            "Last event of match $matchId was not sent, undoing locally only",
            name: runtimeType.toString(),
            level: AppLogLevel.warning,
          );
        }
      }

      if (!ref.mounted) return false;

      state = point.state;
      log("Undid last action for match $matchId", name: runtimeType.toString());
      return true;
    } catch (e, st) {
      log(
        "Error while undo",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );

      // Оставляем возможность повторить отмену.
      _undoPoint = point;
      return false;
    } finally {
      _isUndoing = false;
    }
  }

  Future<void> finishMatch() async {
    if (_isUndoing) {
      log(
        "Ignoring finishMatch while undo is in progress",
        name: runtimeType.toString(),
        level: AppLogLevel.warning,
      );
      return;
    }

    final currentState = state;
    if (currentState is! GameStateLineupSelection) {
      log(
        "Invalid state, can not finish match in ${currentState.runtimeType} state",
        name: runtimeType.toString(),
        level: AppLogLevel.warning,
      );
      return;
    }

    final matchId = currentState.match.id;
    final repository = ref.read(matchesRepositoryProvider);
    final queue = ref.read(matchEventQueueProvider);
    final undoPointBeforeFinish = _undoPoint;

    log("Finishing match $matchId", name: runtimeType.toString());

    // Сразу уводим экран в состояние «Завершаем матч», иначе игрок может
    // нажать «Окончить матч» ещё раз, пока очередь досылает события.
    state = GameStateFinished(match: currentState.match, isSyncing: true);
    _undoPoint = null;

    try {
      // Сначала дожидаемся последних событий, иначе сервер посчитает
      // статистику без них.
      await queue.drain(matchId);
      await repository.endMatch(matchId, DateTime.now());

      if (!ref.mounted) return;

      ref.invalidate(matchDetailProvider);
      ref.invalidate(matchesListProvider);

      log("Match $matchId finished", name: runtimeType.toString());

      state = GameStateFinished(match: currentState.match);
    } catch (e, st) {
      log(
        "Error while finishMatch",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );

      // Возвращаем экран в рабочее состояние, чтобы можно было попробовать
      // завершить матч снова.
      if (!ref.mounted) return;
      _undoPoint = undoPointBeforeFinish;
      state = currentState;
    }
  }
}
