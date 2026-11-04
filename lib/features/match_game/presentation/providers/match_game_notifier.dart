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

  /// Состояние до последнего действия. Живёт только до одной отмены.
  MatchGameState? _previousState;

  /// Результат отправки последнего события. `null`, если действие не создало
  /// событий (например, выбор состава).
  Future<bool>? _lastEventSend;

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
  bool get canUndo => _previousState != null && !_isUndoing;

  bool get isUndoing => _isUndoing;

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
    _previousState = previous;
    _lastEventSend = null;

    // Движок создаёт не больше одного события на действие, поэтому для
    // отмены достаточно одного undo-запроса.
    final queue = ref.read(matchEventQueueProvider);
    for (final event in transition.events) {
      _lastEventSend = queue.enqueue(state.match.id, event);
    }
  }

  /// Откатывает последнее действие и, если оно создало событие, удаляет это
  /// событие на сервере.
  ///
  /// Возвращает `true`, если состояние удалось откатить.
  Future<bool> undo() async {
    final previous = _previousState;
    if (previous == null || _isUndoing) return false;

    final current = state;
    final matchId = current.match.id;
    final lastEventSend = _lastEventSend;
    final queue = ref.read(matchEventQueueProvider);

    _isUndoing = true;
    _previousState = null;

    log(
      "Undoing ${current.runtimeType} -> ${previous.runtimeType} "
      "for match $matchId",
      name: runtimeType.toString(),
    );

    try {
      if (lastEventSend != null) {
        // Дожидаемся отправки последнего события, иначе отмена удалит на
        // сервере чужое (предыдущее) событие.
        final sent = await lastEventSend;

        if (sent) {
          // Отмена встаёт в ту же очередь, что и события, поэтому на сервер
          // она уйдёт после всех уже поставленных запросов.
          final undone = await queue.enqueueUndo(matchId);

          if (!undone) {
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

      state = previous;
      _lastEventSend = null;

      if (lastEventSend != null) {
        ref.invalidate(matchDetailProvider);
        ref.invalidate(matchesListProvider);
      }

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
      _previousState = previous;
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
    final previousBeforeFinish = _previousState;

    log("Finishing match $matchId", name: runtimeType.toString());

    // Сразу уводим экран в состояние «Завершаем матч», иначе игрок может
    // нажать «Окончить матч» ещё раз, пока очередь досылает события.
    state = GameStateFinished(match: currentState.match, isSyncing: true);
    _previousState = null;

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
      _previousState = previousBeforeFinish;
      state = currentState;
    }
  }
}
