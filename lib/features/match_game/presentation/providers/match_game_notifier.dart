import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/di.dart';
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

  /// Единственная точка изменения состояния игры.
  ///
  /// Перевод состояния и события для сервера вычисляет [MatchGameEngine].
  void dispatch(MatchAction action) {
    final transition = _engine.apply(state, action);

    if (transition == null) {
      log(
        "Action ${action.runtimeType} is not allowed in ${state.runtimeType} state",
        name: runtimeType.toString(),
      );
      return;
    }

    state = transition.state;

    final queue = ref.read(matchEventQueueProvider);
    for (final event in transition.events) {
      queue.enqueue(state.match.id, event);
    }
  }

  Future<void> finishMatch() async {
    final currentState = state;
    if (currentState is! GameStateLineupSelection) {
      log(
        "Invalid state, can not finish match in ${currentState.runtimeType} state",
        name: runtimeType.toString(),
      );
      return;
    }

    final matchId = currentState.match.id;
    final repository = ref.read(matchesRepositoryProvider);
    final queue = ref.read(matchEventQueueProvider);

    try {
      // Сначала дожидаемся последних событий, иначе сервер посчитает
      // статистику без них.
      await queue.drain(matchId);
      await repository.endMatch(matchId, DateTime.now());

      if (!ref.mounted) return;

      state = GameStateFinished(match: currentState.match);

      ref.invalidate(matchDetailProvider);
      ref.invalidate(matchesListProvider);
    } catch (e, st) {
      log(
        "Error while finishMatch",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
    }
  }
}
