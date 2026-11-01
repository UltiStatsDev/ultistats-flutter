import 'dart:async';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_game_state.dart';
import 'package:ultistats/features/matches/domain/game/match_action.dart';
import 'package:ultistats/features/matches/domain/game/match_game_engine.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail/match_detail_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_list/matches_list_notifier.dart';

import 'match_timer_notifier.dart';

part 'match_game_notifier.g.dart';

@riverpod
class MatchGameNotifier extends _$MatchGameNotifier {
  static const _engine = MatchGameEngine();

  final List<Event> _matchEvents = [];
  Future<void>? _eventProcessingChain;

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
  /// Перевод состояния и события для сервера вычисляет [MatchGameEngine],
  /// поэтому новые действия не разрастаются методами в этом классе.
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

    for (final event in transition.events) {
      unawaited(_recordAndSendEvent(event));
    }
  }

  Future<void> _recordAndSendEvent(Event event) async {
    _matchEvents.add(event);

    final previousTask = _eventProcessingChain;
    final completer = Completer<void>();
    _eventProcessingChain = completer.future;

    try {
      if (previousTask != null) {
        await previousTask;
      }

      final repository = ref.read(matchEventsRepositoryProvider);
      await repository.addEvent(
        CreateEventParams(matchId: state.match.id, event: event),
      );
      log("Event sent: ${event.type}", name: runtimeType.toString());
    } catch (e) {
      log("Failed to send event: $e", name: runtimeType.toString());
    } finally {
      completer.complete();
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

    try {
      await ref
          .read(matchesRepositoryProvider)
          .endMatch(currentState.match.id, DateTime.now());

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
