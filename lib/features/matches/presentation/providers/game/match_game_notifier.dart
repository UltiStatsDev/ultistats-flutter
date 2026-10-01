import 'dart:async';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_list_notifier.dart';

import 'match_game_state.dart';

part 'match_game_notifier.g.dart';

@riverpod
class MatchGameNotifier extends _$MatchGameNotifier {
  final List<Event> _matchEvents = [];

  @override
  MatchGameState build(MatchDetail match) {
    return GameStateLineupSelection(match: match);
  }

  Future<void> _recordAndSendEvent(Event event) async {
    _matchEvents.add(event);

    try {
      final repository = ref.read(matchEventsRepositoryProvider);
      await repository.addEvent(
        CreateEventParams(matchId: match.id, event: event),
      );
      log("Event sent: $event", name: runtimeType.toString());
    } catch (e) {
      log("Failed to send event: $e", name: runtimeType.toString());
    }
  }

  void togglePlayer(String participantId, int teamIndex) {
    final currentState = state;
    if (currentState is! GameStateLineupSelection) {
      log(
        "Invalid state, can not toggle player in ${currentState.runtimeType} state",
        name: runtimeType.toString(),
      );
      return;
    }

    if (teamIndex == 0) {
      final selected = Set<String>.from(currentState.team1SelectedIds);
      if (selected.contains(participantId)) {
        selected.remove(participantId);
      } else if (selected.length < 5) {
        selected.add(participantId);
      }
      state = currentState.copyWith(team1SelectedIds: selected);
    } else {
      final selected = Set<String>.from(currentState.team2SelectedIds);
      if (selected.contains(participantId)) {
        selected.remove(participantId);
      } else if (selected.length < 5) {
        selected.add(participantId);
      }
      state = currentState.copyWith(team2SelectedIds: selected);
    }
  }

  void confirmLineupAndStartPull(String pullingTeamId) {
    final currentState = state;
    if (currentState is! GameStateLineupSelection) {
      log(
        "Invalid state, can not confirm lineup and start pull in ${currentState.runtimeType} state",
        name: runtimeType.toString(),
      );
      return;
    }

    if (currentState.team1SelectedIds.length != 5 ||
        currentState.team2SelectedIds.length != 5) {
      log(
        "Invalid state, lineup is not complete (5v5 required)",
        name: runtimeType.toString(),
      );
      return;
    }

    final team1 = currentState.match.teams[0];
    final team2 = currentState.match.teams[1];

    final team1Lineup = team1.participants
        .where((p) => currentState.team1SelectedIds.contains(p.participantId))
        .toList();
    final team2Lineup = team2.participants
        .where((p) => currentState.team2SelectedIds.contains(p.participantId))
        .toList();

    team1Lineup.addAll(
      team1.participants.where((p) => p.kind == ParticipantKind.unknown),
    );
    team2Lineup.addAll(
      team2.participants.where((p) => p.kind == ParticipantKind.unknown),
    );

    // Определяем, кто пулит (активная команда)
    final isTeam1Pulling = pullingTeamId == team1.id;

    final activeTeam = isTeam1Pulling ? team1 : team2;
    final opponentTeam = isTeam1Pulling ? team2 : team1;

    final activeLineup = isTeam1Pulling ? team1Lineup : team2Lineup;
    final opponentLineup = isTeam1Pulling ? team2Lineup : team1Lineup;

    state = GameStatePullerSelection(
      match: currentState.match,
      activeTeam: activeTeam,
      activeTeamLineup: activeLineup,
      opponentTeam: opponentTeam,
      opponentTeamLineup: opponentLineup,
    );
  }

  void selectPuller(MatchParticipant puller) {
    final currentState = state;
    if (currentState is! GameStatePullerSelection) {
      log(
        "Invalid state, can not select puller in ${currentState.runtimeType} state",
        name: runtimeType.toString(),
      );
      return;
    }

    _recordAndSendEvent(Event.pull(participantId: puller.participantId));

    state = GameStateTakerSelection(
      match: currentState.match,
      activeTeam: currentState.opponentTeam,
      // Меняем команду местами
      activeTeamLineup: currentState.opponentTeamLineup,
      opponentTeam: currentState.activeTeam,
      opponentTeamLineup: currentState.activeTeamLineup,
    );
  }

  void selectTaker(MatchParticipant taker) {
    final currentState = state;
    if (currentState is! GameStateTakerSelection) {
      log(
        "Invalid state, can not select taker in ${currentState.runtimeType} state",
        name: runtimeType.toString(),
      );
      return;
    }

    _recordAndSendEvent(Event.pickup(participantId: taker.participantId));

    state = GameStatePlaying(
      match: currentState.match,
      activeTeam: currentState.activeTeam,
      activeTeamLineup: currentState.activeTeamLineup,
      opponentTeam: currentState.opponentTeam,
      opponentTeamLineup: currentState.opponentTeamLineup,
      currentThrower: taker,
    );
  }

  void passTo(MatchParticipant receiver) {
    final currentState = state;
    if (currentState is! GameStatePlaying) {
      log(
        "Invalid state, can not pass to player in ${currentState.runtimeType} state",
        name: runtimeType.toString(),
      );
      return;
    }

    _recordAndSendEvent(
      Event2.pass(
        participantId: currentState.currentThrower.participantId,
        toParticipantId: receiver.participantId,
      ),
    );

    state = GameStatePlaying(
      match: currentState.match,
      activeTeam: currentState.activeTeam,
      activeTeamLineup: currentState.activeTeamLineup,
      opponentTeam: currentState.opponentTeam,
      opponentTeamLineup: currentState.opponentTeamLineup,
      currentThrower: receiver,
    );
  }

  void turnover() {
    final currentState = state;
    if (currentState is! GameStatePlaying) {
      log(
        "Invalid state, can not declare turnover in ${currentState.runtimeType} state",
        name: runtimeType.toString(),
      );
      return;
    }

    _recordAndSendEvent(
      Event.incompletePass(participantId: currentState.currentThrower.participantId),
    );

    state = GameStateTakerSelection(
      match: currentState.match,
      activeTeam: currentState.opponentTeam,
      // Смена владения
      activeTeamLineup: currentState.opponentTeamLineup,
      opponentTeam: currentState.activeTeam,
      opponentTeamLineup: currentState.activeTeamLineup,
    );
  }

  void scoreGoal(MatchParticipant scorer) {
    final currentState = state;
    if (currentState is! GameStatePlaying) {
      log(
        "Invalid state, can not score goal in ${currentState.runtimeType} state",
        name: runtimeType.toString(),
      );
      return;
    }

    _recordAndSendEvent(
      Event2.goal(
        participantId: currentState.currentThrower.participantId,
        toParticipantId: scorer.participantId,
      ),
    );

    state = GameStateLineupSelection(match: currentState.match);
  }

  void finishMatch() async {
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

      ref.invalidate(matchDetailProvider);
      ref.invalidate(matchesListProvider);

      state = GameStateFinished();
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
