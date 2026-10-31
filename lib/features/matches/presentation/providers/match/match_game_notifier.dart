import 'dart:async';

import 'package:dio/dio.dart';
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
  // Only one pre-action state is retained. The journal below contains server
  // events for consistency checks, never a history of UI states.
  _UndoSnapshot? _undo;
  List<Event>? _journal;
  _PendingUndo? _pendingUndo;
  bool _isBusy = false;
  bool _requiresReload = false;
  String? _message;

  bool get isBusy => _isBusy;
  bool get requiresReload => _requiresReload;
  String? get message => _message;
  bool get canInteract =>
      !_isBusy &&
      !_requiresReload &&
      state is! GameStateFinished &&
      state is! GameStateError;
  bool get canUndo => canInteract && _undo != null;
  bool get canCheckPendingAction => !_isBusy && _pendingUndo != null;

  @override
  MatchGameState build(MatchDetail match) {
    final initialElapsed = match.startedAt != null
        ? DateTime.now().difference(match.startedAt!)
        : Duration.zero;
    Future.microtask(() {
      if (!ref.mounted || state is GameStateFinished) return;
      ref
          .read(matchTimerProvider(match.id).notifier)
          .start(initialDuration: initialElapsed);
    });
    return GameStateLineupSelection(match: match);
  }

  Future<void> _recordAndSendEvent(Event event) async {
    final before = state;
    final previousUndo = _undo;
    final keepAlive = ref.keepAlive();
    var sent = false;
    _undo = null;
    _isBusy = true;
    _message = null;
    ref.notifyListeners();
    try {
      final repository = ref.read(matchEventsRepositoryProvider);
      _journal ??= _ordered(await repository.getEvents(match.id));
      if (!ref.mounted) return;
      sent = true;
      final stored = await repository.addEvent(
        CreateEventParams(matchId: match.id, event: event),
      );
      if (!ref.mounted) return;
      if (stored.id == null ||
          stored.sequenceNumber == null ||
          (_journal!.isNotEmpty &&
              stored.sequenceNumber! <= _journal!.last.sequenceNumber!) ||
          stored.type != event.type ||
          _participants(stored) != _participants(event)) {
        _requireReload();
        return;
      }
      _journal!.add(stored);
      _undo = _UndoSnapshot(before: before, event: stored);
    } catch (error, stack) {
      if (!ref.mounted) return;
      log('Event write failed', error: error, stackTrace: stack);
      if (!sent || _isDefiniteRejection(error)) {
        state = before;
        _undo = previousUndo;
        _message = sent
            ? 'Событие отклонено сервером. Действие не сохранено.'
            : 'Не удалось загрузить журнал. Действие не отправлено.';
      } else {
        _requireReload();
      }
    } finally {
      if (ref.mounted) {
        _isBusy = false;
        ref.notifyListeners();
      }
      keepAlive.close();
    }
  }

  Future<void> undoLastAction() async {
    if (!canUndo) return;
    final snapshot = _undo!;
    _message = null;
    if (snapshot.event == null) {
      _undo = null;
      state = snapshot.before;
      return;
    }
    final keepAlive = ref.keepAlive();
    _isBusy = true;
    ref.notifyListeners();
    try {
      final repository = ref.read(matchEventsRepositoryProvider);
      final events = _ordered(await repository.getEvents(match.id));
      if (!ref.mounted) return;
      if (events.isEmpty ||
          events.last.id != snapshot.event!.id ||
          !_sameEvents(events, _journal!)) {
        _requireReload();
        return;
      }
      _pendingUndo = _PendingUndo(snapshot: snapshot, events: events);
      // Consume the only undo slot when dispatching this non-idempotent POST.
      // A second attempt is never issued for the same action.
      _undo = null;
      try {
        final removed = await repository.undoLastEvent(match.id);
        if (!ref.mounted) return;
        if (_sameEvents([removed], [snapshot.event!])) {
          _restore(snapshot);
        } else {
          _requireReload();
        }
      } catch (error) {
        if (!ref.mounted) return;
        _pendingUndo!.rejected = _isDefiniteRejection(error);
        _message = _undoError(error);
        await _reconcileUndo();
      }
    } catch (_) {
      if (ref.mounted) {
        _message = 'Не удалось проверить журнал. Запрос отмены не отправлен.';
      }
    } finally {
      if (ref.mounted) {
        _isBusy = false;
        ref.notifyListeners();
      }
      keepAlive.close();
    }
  }

  /// Only GET is repeated after an uncertain response, never POST /undo.
  Future<void> checkPendingAction() async {
    if (!canCheckPendingAction) return;
    final keepAlive = ref.keepAlive();
    _isBusy = true;
    ref.notifyListeners();
    try {
      await _reconcileUndo();
    } finally {
      if (ref.mounted) {
        _isBusy = false;
        ref.notifyListeners();
      }
      keepAlive.close();
    }
  }

  Future<void> _reconcileUndo() async {
    final pending = _pendingUndo!;
    try {
      final events = _ordered(
        await ref.read(matchEventsRepositoryProvider).getEvents(match.id),
      );
      if (!ref.mounted) return;
      if (_sameEvents(
        events,
        pending.events.sublist(0, pending.events.length - 1),
      )) {
        _restore(pending.snapshot);
        _message = 'Действие отменено. Результат проверен на сервере.';
      } else if (_sameEvents(events, pending.events)) {
        if (pending.rejected) {
          _pendingUndo = null;
          _requiresReload = false;
          // The action still exists; a new action can arm the next undo slot.
        } else {
          _requiresReload = true;
          _message =
              'Результат отмены пока неизвестен. Проверьте отмену перед продолжением.';
        }
      } else {
        _requireReload();
      }
    } catch (_) {
      if (!ref.mounted) return;
      _requiresReload = true;
      _message =
          'Не удалось проверить отмену. Проверьте её перед продолжением.';
    }
  }

  void _restore(_UndoSnapshot snapshot) {
    _undo = null;
    _pendingUndo = null;
    _requiresReload = false;
    _journal!.removeLast();
    state = snapshot.before;
    _invalidateMatch();
  }

  void _requireReload() {
    _undo = null;
    _pendingUndo = null;
    _requiresReload = true;
    _message =
        'Журнал матча изменился или результат записи неизвестен. Проверьте матч перед продолжением; можно выйти к карточке матча.';
    _invalidateMatch();
  }

  void _invalidateMatch() {
    ref.invalidate(matchDetailProvider);
    ref.invalidate(matchesListProvider);
  }

  bool _isDefiniteRejection(Object error) =>
      error is DioException &&
      const [400, 401, 403, 404, 409, 422].contains(error.response?.statusCode);

  String _undoError(Object error) {
    if (error is DioException) {
      if (error.response?.statusCode == 404) {
        return 'Нет события для отмены или матч недоступен.';
      }
      if (error.response?.statusCode == 409) {
        return 'Отмена отклонена сервером для текущего состояния матча.';
      }
    }
    return 'Ответ на отмену не получен. Проверяем результат.';
  }

  List<Event> _ordered(List<Event> events) {
    if (events.any((e) => e.id == null || e.sequenceNumber == null)) {
      throw StateError('Missing server event identity');
    }
    return List<Event>.of(events)
      ..sort((a, b) => a.sequenceNumber!.compareTo(b.sequenceNumber!));
  }

  bool _sameEvents(List<Event> left, List<Event> right) {
    if (left.length != right.length) return false;
    for (var i = 0; i < left.length; i++) {
      final a = left[i];
      final b = right[i];
      if (a.id != b.id ||
          a.sequenceNumber != b.sequenceNumber ||
          a.type != b.type ||
          !a.occurredAt.isAtSameMomentAs(b.occurredAt) ||
          _participants(a) != _participants(b)) {
        return false;
      }
    }
    return true;
  }

  (String?, String?, String?) _participants(Event event) => switch (event) {
    Event2 e => (e.participantId, e.toParticipantId, null),
    Event1 e => (e.participantId, null, null),
    TeamEvent e => (null, null, e.teamId),
    MatchEvent() => (null, null, null),
  };

  void togglePlayer(String participantId, int teamIndex) {
    if (!canInteract) return;
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
    if (!canInteract) return;
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

    _undo = _UndoSnapshot(before: currentState);
    _message = null;
    state = GameStatePullerSelection(
      match: currentState.match,
      activeTeam: activeTeam,
      activeTeamLineup: isTeam1Pulling ? team1Lineup : team2Lineup,
      opponentTeam: opponentTeam,
      opponentTeamLineup: isTeam1Pulling ? team2Lineup : team1Lineup,
    );
  }

  void selectPuller(MatchParticipant puller) {
    if (!canInteract) return;
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
    if (!canInteract) return;
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
    if (!canInteract) return;
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
    if (!canInteract) return;
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
    if (!canInteract) return;
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
    if (!canInteract) return;
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
    _recordAndSendEvent(event);
    state = GameStateTimeout(
      resumeState: currentState,
      startedAt: event.occurredAt,
    );
  }

  void endTimeout(MatchTeam team) {
    if (!canInteract) return;
    final currentState = state;
    if (currentState is! GameStateTimeout || currentState.team.id != team.id) {
      return;
    }

    _recordAndSendEvent(TeamEvent.timeoutEnd(teamId: currentState.team.id));
    state = currentState.resumeState;
  }

  void startHalftime() {
    if (!canInteract) return;
    final currentState = state;
    if (currentState is! GameStateLineupSelection) {
      log(
        "Халфтайм возможен только между очками",
        name: runtimeType.toString(),
      );
      return;
    }
    final event = MatchEvent.halftimeStart();
    _recordAndSendEvent(event);
    state = GameStateHalftime(
      resumeState: currentState,
      startedAt: event.occurredAt,
    );
  }

  void endHalftime() {
    if (!canInteract) return;
    final currentState = state;
    if (currentState is! GameStateHalftime) {
      return;
    }

    _recordAndSendEvent(MatchEvent.halftimeEnd());
    state = currentState.resumeState;
  }

  Future<void> finishMatch() async {
    if (!canInteract || state is! GameStateLineupSelection) return;
    final before = state;
    final keepAlive = ref.keepAlive();
    _isBusy = true;
    _message = null;
    ref.notifyListeners();
    try {
      await ref
          .read(matchesRepositoryProvider)
          .endMatch(before.match.id, DateTime.now());
      if (!ref.mounted) return;
      _undo = null;
      state = GameStateFinished(match: before.match);
      ref.read(matchTimerProvider(match.id).notifier).pause();
      _invalidateMatch();
    } catch (error, stack) {
      if (!ref.mounted) return;
      _message = 'Не удалось завершить матч. Попробуйте ещё раз.';
      log('Error while finishMatch', error: error, stackTrace: stack);
    } finally {
      if (ref.mounted) {
        _isBusy = false;
        ref.notifyListeners();
      }
      keepAlive.close();
    }
  }
}

class _UndoSnapshot {
  const _UndoSnapshot({required this.before, this.event});
  final MatchGameState before;
  final Event? event;
}

class _PendingUndo {
  _PendingUndo({required this.snapshot, required this.events});
  final _UndoSnapshot snapshot;
  final List<Event> events;
  bool rejected = false;
}
