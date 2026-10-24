import 'dart:developer';

import 'package:dio/dio.dart';

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
  final List<_EventSnapshot> _history = [];
  List<Event>? _knownEvents;
  bool _isBusy = false;
  bool _needsSync = false;
  String? _message;
  _PendingUndo? _pendingUndo;

  bool get isBusy => _isBusy;
  bool get needsSync => _needsSync;
  String? get message => _message;
  bool get canInteract =>
      !_isBusy && !_needsSync && state is! GameStateFinished;
  bool get canUndo => canInteract && _history.isNotEmpty;
  bool get canSynchronize => !_isBusy && _pendingUndo != null;

  @override
  MatchGameState build(MatchDetail match) {
    final initialElapsed = match.startedAt != null
        ? DateTime.now().difference(match.startedAt!)
        : Duration.zero;

    Future.microtask(() {
      if (!ref.mounted) return;
      ref
          .read(matchTimerProvider(match.id).notifier)
          .start(initialDuration: initialElapsed);
    });

    return GameStateLineupSelection(match: match);
  }

  // Serialize mutations: a second tap must never overtake an unacknowledged event.
  Future<void> _recordAndSendEvent(Event event) async {
    final before = state;
    var requestStarted = false;
    final keepAlive = ref.keepAlive();
    _isBusy = true;
    _message = null;
    ref.notifyListeners();
    try {
      final repository = ref.read(matchEventsRepositoryProvider);
      _knownEvents ??= _orderedEvents(await repository.getEvents(match.id));
      if (!ref.mounted) return;
      requestStarted = true;
      final stored = await repository.addEvent(
        CreateEventParams(matchId: match.id, event: event),
      );
      if (!ref.mounted) return;
      if (stored.id == null) {
        _requireReopen();
      } else {
        _knownEvents!.add(stored);
        _history.add(_EventSnapshot(event: stored, before: before));
      }
    } catch (error) {
      if (!ref.mounted) return;
      if (!requestStarted) {
        state = before;
        _updateTimer();
        _message =
            'Не удалось загрузить журнал. Событие не отправлено, повторите действие.';
      } else if (error is DioException &&
          (error.response?.statusCode == 400 ||
              error.response?.statusCode == 404 ||
              error.response?.statusCode == 409 ||
              error.response?.statusCode == 422)) {
        state = before;
        _updateTimer();
        _message =
            'Событие отклонено сервером. Повторите действие после проверки матча.';
      } else {
        // A lost create response may already have changed the server. Do not
        // record another event against an uncertain local state.
        _requireReopen();
      }
    } finally {
      if (ref.mounted) {
        _isBusy = false;
        ref.notifyListeners();
      }
      keepAlive.close();
    }
  }

  Future<void> undoLastEvent() async {
    if (!canUndo) return;
    final keepAlive = ref.keepAlive();
    _isBusy = true;
    _message = null;
    ref.notifyListeners();
    final snapshot = _history.last;
    try {
      final repository = ref.read(matchEventsRepositoryProvider);
      final events = await repository.getEvents(match.id);
      if (!ref.mounted) return;
      final ordered = _orderedEvents(events);
      if (ordered.isEmpty ||
          ordered.last.id != snapshot.event.id ||
          !_sameEvents(ordered, _knownEvents!)) {
        _requireReopen();
        return;
      }
      _pendingUndo = _PendingUndo(snapshot: snapshot, events: ordered);
      try {
        // Non-idempotent: never automatically retry this POST.
        final removed = await repository.undoLastEvent(match.id);
        if (!ref.mounted) return;
        if (removed.id == snapshot.event.id) {
          _restore(snapshot);
          _pendingUndo = null;
        } else {
          _pendingUndo = null;
          _requireReopen();
        }
      } catch (error) {
        if (!ref.mounted) return;
        _message = _undoErrorMessage(error);
        _pendingUndo!.errorMessage = _message;
        await _reconcileUndo();
      }
    } catch (error) {
      if (ref.mounted) {
        // No POST was sent if the initial journal read failed.
        _message = 'Не удалось проверить журнал событий. Попробуйте ещё раз.';
      }
    } finally {
      if (ref.mounted) {
        _isBusy = false;
        ref.notifyListeners();
      }
      keepAlive.close();
    }
  }

  /// Retry only the read after an ambiguous response, never the undo request.
  Future<void> synchronize() async {
    if (!canSynchronize) return;
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
      final events = await ref
          .read(matchEventsRepositoryProvider)
          .getEvents(match.id);
      if (!ref.mounted) return;
      final ordered = _orderedEvents(events);
      if (_sameEvents(
        ordered,
        pending.events.sublist(0, pending.events.length - 1),
      )) {
        _restore(pending.snapshot);
        _message =
            'Последнее событие отменено. Состояние проверено на сервере.';
        _needsSync = false;
        _pendingUndo = null;
      } else if (_sameEvents(ordered, pending.events)) {
        _needsSync = false;
        _pendingUndo = null;
        _message =
            pending.errorMessage ??
            'Событие не отменено. Можно повторить отмену.';
      } else {
        _pendingUndo = null;
        _requireReopen();
      }
    } catch (_) {
      if (!ref.mounted) return;
      _needsSync = true;
      _message =
          'Не удалось проверить результат отмены. Обновите состояние перед продолжением.';
    }
  }

  List<Event> _orderedEvents(List<Event> events) {
    final ordered = List<Event>.of(
      events,
    )..sort((a, b) => (a.sequenceNumber ?? 0).compareTo(b.sequenceNumber ?? 0));
    if (ordered.any(
      (event) => event.id == null || event.sequenceNumber == null,
    )) {
      throw StateError('Server event identity is missing');
    }
    return ordered;
  }

  bool _sameEvents(List<Event> a, List<Event> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      final left = a[i];
      final right = b[i];
      if (left.id != right.id ||
          left.sequenceNumber != right.sequenceNumber ||
          left.type != right.type ||
          !left.occurredAt.isAtSameMomentAs(right.occurredAt) ||
          _participants(left) != _participants(right)) {
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

  void _restore(_EventSnapshot snapshot) {
    _history.removeLast();
    _knownEvents!.removeLast();
    state = snapshot.before;
    _updateTimer();
    _invalidateMatch();
  }

  void _requireReopen() {
    _needsSync = true;
    _message =
        'Журнал матча изменился или результат запроса неизвестен. Вернитесь к карточке матча и откройте его заново.';
    _invalidateMatch();
  }

  void _invalidateMatch() {
    ref.invalidate(matchDetailProvider);
    ref.invalidate(matchesListProvider);
  }

  void _updateTimer() {
    final timer = ref.read(matchTimerProvider(match.id).notifier);
    if (state is GameStateBreak || state is GameStateFinished) {
      timer.pause();
    } else {
      timer.start();
    }
  }

  String _undoErrorMessage(Object error) {
    if (error is DioException) {
      switch (error.response?.statusCode) {
        case 404:
          return 'Нет событий для отмены или матч недоступен.';
        case 409:
          return 'Отмена невозможна в текущем состоянии матча.';
      }
    }
    return 'Ответ на отмену не получен. Проверяем журнал событий.';
  }

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
    final current = state;
    if (current is! GameStatePlaying || current.activeTeam.id != team.id) {
      return;
    }
    _recordAndSendEvent(TeamEvent.timeoutStart(teamId: team.id));
    state = GameStateBreak(
      previousState: current,
      team: team,
      startedAt: DateTime.now(),
    );
    _updateTimer();
  }

  void endTimeout(MatchTeam team) {
    if (!canInteract) return;
    final current = state;
    if (current is! GameStateBreak || current.team?.id != team.id) return;
    _recordAndSendEvent(TeamEvent.timeoutEnd(teamId: team.id));
    state = current.previousState;
    _updateTimer();
  }

  void startHalftime() {
    if (!canInteract || state is! GameStateLineupSelection) return;
    final current = state;
    _recordAndSendEvent(MatchEvent.halftimeStart());
    state = GameStateBreak(previousState: current, startedAt: DateTime.now());
    _updateTimer();
  }

  void endHalftime() {
    if (!canInteract) return;
    final current = state;
    if (current is! GameStateBreak || current.team != null) return;
    _recordAndSendEvent(MatchEvent.halftimeEnd());
    state = current.previousState;
    _updateTimer();
  }

  void finishMatch() async {
    if (!canInteract) return;
    final currentState = state;
    if (currentState is! GameStateLineupSelection) {
      log(
        "Invalid state, can not finish match in ${currentState.runtimeType} state",
        name: runtimeType.toString(),
      );
      return;
    }

    final keepAlive = ref.keepAlive();
    _isBusy = true;
    ref.notifyListeners();
    try {
      await ref
          .read(matchesRepositoryProvider)
          .endMatch(currentState.match.id, DateTime.now());

      if (!ref.mounted) return;
      _invalidateMatch();
      _history.clear();
      state = GameStateFinished(match: currentState.match);
      _updateTimer();
    } catch (e, st) {
      if (!ref.mounted) return;
      _message = 'Не удалось завершить матч. Попробуйте ещё раз.';
      log(
        "Error while finishMatch",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
    } finally {
      if (ref.mounted) {
        _isBusy = false;
        ref.notifyListeners();
      }
      keepAlive.close();
    }
  }
}

class _EventSnapshot {
  const _EventSnapshot({required this.event, required this.before});
  final Event event;
  final MatchGameState before;
}

class _PendingUndo {
  _PendingUndo({required this.snapshot, required this.events});
  final _EventSnapshot snapshot;
  final List<Event> events;
  String? errorMessage;
}
