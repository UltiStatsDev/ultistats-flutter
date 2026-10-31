import 'dart:async';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_timer_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail/match_detail_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_list/matches_list_notifier.dart';

import 'match_game_state.dart';

part 'match_game_notifier.g.dart';

@riverpod
class MatchGameNotifier extends _$MatchGameNotifier {
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
        CreateEventParams(matchId: match.id, event: event),
      );
      log("Event sent: ${event.type}", name: runtimeType.toString());
    } catch (e) {
      log("Failed to send event: $e", name: runtimeType.toString());
    } finally {
      completer.complete();
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
      } else if (selected.length < match.playersPerTeam) {
        selected.add(participantId);
      }
      state = currentState.copyWith(team1SelectedIds: selected);
    } else {
      final selected = Set<String>.from(currentState.team2SelectedIds);
      if (selected.contains(participantId)) {
        selected.remove(participantId);
      } else if (selected.length < match.playersPerTeam) {
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

    if (currentState.team1SelectedIds.length != match.playersPerTeam ||
        currentState.team2SelectedIds.length != match.playersPerTeam) {
      log(
        "Invalid state, lineup is not complete (${match.playersPerTeam} required)",
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

    final isTeam1Pulling = pullingTeamId == team1.id;
    final activeTeam = isTeam1Pulling ? team1 : team2;
    final opponentTeam = isTeam1Pulling ? team2 : team1;

    state = GameStatePullerSelection(
      match: currentState.match,
      activeTeam: activeTeam,
      activeTeamLineup: isTeam1Pulling ? team1Lineup : team2Lineup,
      opponentTeam: opponentTeam,
      opponentTeamLineup: isTeam1Pulling ? team2Lineup : team1Lineup,
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

    _recordAndSendEvent(Event1.pull(participantId: puller.participantId));

    state = GameStateTakerSelection(
      match: currentState.match,
      activeTeam: currentState.opponentTeam,
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

    _recordAndSendEvent(Event1.pickup(participantId: taker.participantId));

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
      Event1.incompletePass(
        participantId: currentState.currentThrower.participantId,
      ),
    );

    state = GameStateTakerSelection(
      match: currentState.match,
      activeTeam: currentState.opponentTeam,
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

    final match = currentState.match;
    final team1Id = match.teams[0].id;

    final updatedTeams = match.teams.map((team) {
      if (team.id == currentState.activeTeam.id) {
        return team.copyWith(score: team.score + 1);
      }
      return team;
    }).toList();

    final updatedMatch = match.copyWith(teams: updatedTeams);

    final isTeam1Active = currentState.activeTeam.id == team1Id;

    final team1Lineup = isTeam1Active
        ? currentState.activeTeamLineup
        : currentState.opponentTeamLineup;

    final team2Lineup = isTeam1Active
        ? currentState.opponentTeamLineup
        : currentState.activeTeamLineup;

    final team1SelectedIds = team1Lineup
        .where((p) => p.kind == ParticipantKind.player)
        .map((p) => p.participantId)
        .toSet();

    final team2SelectedIds = team2Lineup
        .where((p) => p.kind == ParticipantKind.player)
        .map((p) => p.participantId)
        .toSet();

    state = GameStateLineupSelection(
      match: updatedMatch,
      team1SelectedIds: team1SelectedIds,
      team2SelectedIds: team2SelectedIds,
    );
  }

  void startTimeout(MatchTeam team) {
    final currentState = state;

    if (currentState is! GameStatePlaying) {
      log("Таймаут запрещен", name: runtimeType.toString());
      return;
    }

    if (currentState.activeTeam.id != team.id) {
      log("Таймаут запрещен: диск у соперника", name: runtimeType.toString());
      return;
    }

    final event = TeamEvent.timeoutStart(teamId: team.id);
    ref.read(matchTimerProvider(match.id).notifier).pause();
    state = GameStateTimeout(
      resumeState: currentState,
      startedAt: event.occurredAt,
    );
    _recordAndSendEvent(event);
  }

  void endTimeout(MatchTeam team) {
    final currentState = state;
    if (currentState is! GameStateTimeout || currentState.team.id != team.id) {
      return;
    }

    _recordAndSendEvent(TeamEvent.timeoutEnd(teamId: currentState.team.id));
    state = currentState.resumeState;
    ref.read(matchTimerProvider(match.id).notifier).start();
  }

  void startHalftime() {
    final currentState = state;
    if (currentState is! GameStateLineupSelection) {
      log(
        "Халфтайм возможен только между очками",
        name: runtimeType.toString(),
      );
      return;
    }
    final event = MatchEvent.halftimeStart();
    ref.read(matchTimerProvider(match.id).notifier).pause();
    state = GameStateHalftime(
      resumeState: currentState,
      startedAt: event.occurredAt,
    );
    _recordAndSendEvent(event);
  }

  void endHalftime() {
    final currentState = state;
    if (currentState is! GameStateHalftime) {
      return;
    }

    _recordAndSendEvent(MatchEvent.halftimeEnd());
    state = currentState.resumeState;
    ref.read(matchTimerProvider(match.id).notifier).start();
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

      state = GameStateFinished(match: match);
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
