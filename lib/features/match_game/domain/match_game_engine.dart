import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/match_game/domain/match_game_state.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';
import 'package:ultistats/features/match_game/domain/match_action.dart';

/// Результат перехода: новое состояние игры и события, которые нужно отправить.
class MatchGameTransition {
  const MatchGameTransition({required this.state, this.events = const []});

  final MatchGameState state;
  final List<Event> events;
}

/// Доменный автомат матча.
///
/// Чистая логика без Riverpod, Flutter и сети: принимает текущее состояние и
/// действие, возвращает новое состояние вместе со списком событий.
/// `null` означает, что действие в текущем состоянии недопустимо.
class MatchGameEngine {
  const MatchGameEngine();

  MatchGameTransition? apply(MatchGameState current, MatchAction action) {
    return switch (action) {
      TogglePlayerAction() => _togglePlayer(current, action),
      ConfirmLineupAction() => _confirmLineup(current, action),
      SelectPullerAction() => _selectPuller(current, action),
      SelectTakerAction() => _selectTaker(current, action),
      DeclareBrickAction() => _declareBrick(current),
      PassToAction() => _passTo(current, action),
      ThrowAwayAction() => _throwAway(current),
      BlockAction() => _block(current, action),
      InterceptionAction() => _interception(current, action),
      CallahanAction() => _callahan(current, action),
      ScoreGoalAction() => _scoreGoal(current, action),
      StartTimeoutAction() => _startTimeout(current, action),
      EndTimeoutAction() => _endTimeout(current, action),
      StartHalftimeAction() => _startHalftime(current),
      EndHalftimeAction() => _endHalftime(current),
      UndoLastAction() => null,
    };
  }

  MatchGameTransition? _togglePlayer(
    MatchGameState current,
    TogglePlayerAction action,
  ) {
    if (current is! GameStateLineupSelection) return null;

    final isFirstTeam = action.teamIndex == 0;
    final selected = Set<String>.from(
      isFirstTeam ? current.team1SelectedIds : current.team2SelectedIds,
    );

    if (selected.contains(action.participantId)) {
      selected.remove(action.participantId);
    } else if (selected.length < current.match.playersPerTeam) {
      selected.add(action.participantId);
    }

    return MatchGameTransition(
      state: isFirstTeam
          ? current.copyWith(team1SelectedIds: selected)
          : current.copyWith(team2SelectedIds: selected),
    );
  }

  MatchGameTransition? _confirmLineup(
    MatchGameState current,
    ConfirmLineupAction action,
  ) {
    if (current is! GameStateLineupSelection) return null;

    final playersPerTeam = current.match.playersPerTeam;
    if (current.team1SelectedIds.length != playersPerTeam ||
        current.team2SelectedIds.length != playersPerTeam) {
      return null;
    }

    final team1 = current.match.teams[0];
    final team2 = current.match.teams[1];

    final team1Lineup = team1.participants
        .where((p) => current.team1SelectedIds.contains(p.participantId))
        .toList();
    final team2Lineup = team2.participants
        .where((p) => current.team2SelectedIds.contains(p.participantId))
        .toList();

    team1Lineup.addAll(
      team1.participants.where((p) => p.kind == ParticipantKind.unknown),
    );
    team2Lineup.addAll(
      team2.participants.where((p) => p.kind == ParticipantKind.unknown),
    );

    final isTeam1Pulling = action.pullingTeamId == team1.id;

    return MatchGameTransition(
      state: GameStatePullerSelection(
        match: current.match,
        activeTeam: isTeam1Pulling ? team1 : team2,
        activeTeamLineup: isTeam1Pulling ? team1Lineup : team2Lineup,
        opponentTeam: isTeam1Pulling ? team2 : team1,
        opponentTeamLineup: isTeam1Pulling ? team2Lineup : team1Lineup,
      ),
    );
  }

  MatchGameTransition? _selectPuller(
    MatchGameState current,
    SelectPullerAction action,
  ) {
    if (current is! GameStatePullerSelection) return null;

    return MatchGameTransition(
      state: GameStateTakerSelection(
        match: current.match,
        activeTeam: current.opponentTeam,
        activeTeamLineup: current.opponentTeamLineup,
        opponentTeam: current.activeTeam,
        opponentTeamLineup: current.activeTeamLineup,
        pullPuller: action.puller,
      ),
      events: [Event1.pull(participantId: action.puller.participantId)],
    );
  }

  MatchGameTransition? _selectTaker(
    MatchGameState current,
    SelectTakerAction action,
  ) {
    if (current is! GameStateTakerSelection) return null;
    if (!_containsParticipant(
      current.activeTeamLineup,
      action.taker.participantId,
    )) {
      return null;
    }

    return MatchGameTransition(
      state: GameStatePlaying(
        match: current.match,
        activeTeam: current.activeTeam,
        activeTeamLineup: current.activeTeamLineup,
        opponentTeam: current.opponentTeam,
        opponentTeamLineup: current.opponentTeamLineup,
        currentThrower: action.taker,
      ),
      events: [Event1.pickup(participantId: action.taker.participantId)],
    );
  }

  MatchGameTransition? _declareBrick(MatchGameState current) {
    if (current is! GameStateTakerSelection) return null;

    final puller = current.pullPuller;
    if (puller == null) return null;

    return MatchGameTransition(
      state: GameStateTakerSelection(
        match: current.match,
        activeTeam: current.activeTeam,
        activeTeamLineup: current.activeTeamLineup,
        opponentTeam: current.opponentTeam,
        opponentTeamLineup: current.opponentTeamLineup,
      ),
      events: [Event1.brick(participantId: puller.participantId)],
    );
  }

  MatchGameTransition? _passTo(MatchGameState current, PassToAction action) {
    if (current is! GameStatePlaying) return null;
    if (!_canReceive(current, action.receiver.participantId)) return null;

    return MatchGameTransition(
      state: GameStatePlaying(
        match: current.match,
        activeTeam: current.activeTeam,
        activeTeamLineup: current.activeTeamLineup,
        opponentTeam: current.opponentTeam,
        opponentTeamLineup: current.opponentTeamLineup,
        currentThrower: action.receiver,
      ),
      events: [
        Event2.pass(
          participantId: current.currentThrower.participantId,
          toParticipantId: action.receiver.participantId,
        ),
      ],
    );
  }

  MatchGameTransition? _throwAway(MatchGameState current) {
    if (current is! GameStatePlaying) return null;

    return MatchGameTransition(
      state: _pickupState(current.opponentTeam, current),
      events: [
        Event1.incompletePass(
          participantId: current.currentThrower.participantId,
        ),
      ],
    );
  }

  MatchGameTransition? _block(
    MatchGameState current,
    BlockAction action,
  ) {
    if (current is! GameStatePlaying) return null;
    if (!_isOpponentPlayer(current, action.blocker.participantId)) {
      return null;
    }

    final fromId = current.currentThrower.participantId;
    final toId = action.blocker.participantId;
    final event = switch (action.kind) {
      BlockKind.unspecified => Event2.block(
        participantId: fromId,
        toParticipantId: toId,
      ),
      BlockKind.marker => Event2.blockMarker(
        participantId: fromId,
        toParticipantId: toId,
      ),
      BlockKind.field => Event2.blockField(
        participantId: fromId,
        toParticipantId: toId,
      ),
    };

    return MatchGameTransition(
      state: _pickupState(current.opponentTeam, current),
      events: [event],
    );
  }

  MatchGameTransition? _interception(
    MatchGameState current,
    InterceptionAction action,
  ) {
    if (current is! GameStatePlaying) return null;
    if (!_isOpponentPlayer(current, action.interceptor.participantId)) {
      return null;
    }

    return MatchGameTransition(
      state: GameStatePlaying(
        match: current.match,
        activeTeam: current.opponentTeam,
        activeTeamLineup: current.opponentTeamLineup,
        opponentTeam: current.activeTeam,
        opponentTeamLineup: current.activeTeamLineup,
        currentThrower: action.interceptor,
      ),
      events: [
        Event2.interception(
          participantId: current.currentThrower.participantId,
          toParticipantId: action.interceptor.participantId,
        ),
      ],
    );
  }

  MatchGameTransition? _callahan(
    MatchGameState current,
    CallahanAction action,
  ) {
    if (current is! GameStatePlaying) return null;
    if (!_isOpponentPlayer(current, action.interceptor.participantId)) {
      return null;
    }

    final updatedMatch = _addPoint(current.match, current.opponentTeam.id);

    return MatchGameTransition(
      state: _nextPointState(current, updatedMatch),
      events: [
        Event2.callahan(
          participantId: current.currentThrower.participantId,
          toParticipantId: action.interceptor.participantId,
        ),
      ],
    );
  }

  MatchGameTransition? _scoreGoal(
    MatchGameState current,
    ScoreGoalAction action,
  ) {
    if (current is! GameStatePlaying) return null;
    if (!_canReceive(current, action.scorer.participantId)) return null;

    final updatedMatch = _addPoint(current.match, current.activeTeam.id);

    return MatchGameTransition(
      state: _nextPointState(current, updatedMatch),
      events: [
        Event2.goal(
          participantId: current.currentThrower.participantId,
          toParticipantId: action.scorer.participantId,
        ),
      ],
    );
  }

  MatchGameTransition? _startTimeout(
    MatchGameState current,
    StartTimeoutAction action,
  ) {
    if (current is! GameStatePlaying) return null;
    if (current.activeTeam.id != action.team.id) return null;

    final event = TeamEvent.timeoutStart(teamId: action.team.id);

    return MatchGameTransition(
      state: GameStateTimeout(
        resumeState: current,
        startedAt: event.occurredAt,
      ),
      events: [event],
    );
  }

  MatchGameTransition? _endTimeout(
    MatchGameState current,
    EndTimeoutAction action,
  ) {
    if (current is! GameStateTimeout || current.team.id != action.team.id) {
      return null;
    }

    return MatchGameTransition(
      state: current.resumeState,
      events: [TeamEvent.timeoutEnd(teamId: current.team.id)],
    );
  }

  MatchGameTransition? _startHalftime(MatchGameState current) {
    if (current is! GameStateLineupSelection) return null;

    final event = MatchEvent.halftimeStart();

    return MatchGameTransition(
      state: GameStateHalftime(
        resumeState: current,
        startedAt: event.occurredAt,
      ),
      events: [event],
    );
  }

  MatchGameTransition? _endHalftime(MatchGameState current) {
    if (current is! GameStateHalftime) return null;

    return MatchGameTransition(
      state: current.resumeState,
      events: [MatchEvent.halftimeEnd()],
    );
  }

  Set<String> _playerIds(List<MatchParticipant> lineup) => lineup
      .where((p) => p.kind == ParticipantKind.player)
      .map((p) => p.participantId)
      .toSet();

  bool _containsParticipant(List<MatchParticipant> lineup, String id) =>
      lineup.any((p) => p.participantId == id);

  /// Принимать пас или забивать может только партнёр, но не сам бросающий.
  bool _canReceive(GameStatePlaying current, String participantId) {
    if (participantId == current.currentThrower.participantId) return false;
    return _containsParticipant(current.activeTeamLineup, participantId);
  }

  /// Действие защиты выполняет игрок противоположной команды.
  bool _isOpponentPlayer(GameStatePlaying current, String participantId) {
    if (participantId == current.currentThrower.participantId) return false;
    return _containsParticipant(current.opponentTeamLineup, participantId);
  }

  /// Свободный диск подбирает команда [team], которая становится активной.
  GameStateTakerSelection _pickupState(
    MatchTeam team,
    GameStatePlaying current,
  ) {
    final isOpponent = team.id == current.opponentTeam.id;

    return GameStateTakerSelection(
      match: current.match,
      activeTeam: team,
      activeTeamLineup: isOpponent
          ? current.opponentTeamLineup
          : current.activeTeamLineup,
      opponentTeam: isOpponent ? current.activeTeam : current.opponentTeam,
      opponentTeamLineup: isOpponent
          ? current.activeTeamLineup
          : current.opponentTeamLineup,
    );
  }

  MatchDetail _addPoint(MatchDetail match, String teamId) {
    final updatedTeams = match.teams.map((team) {
      if (team.id == teamId) {
        return team.copyWith(score: team.score + 1);
      }
      return team;
    }).toList();

    return match.copyWith(teams: updatedTeams);
  }

  /// Возвращает выбор состава для следующего поинта, сохраняя составы команд.
  GameStateLineupSelection _nextPointState(
    GameStatePlaying current,
    MatchDetail updatedMatch,
  ) {
    final team1Id = current.match.teams[0].id;
    final isTeam1Active = current.activeTeam.id == team1Id;

    final team1Lineup = isTeam1Active
        ? current.activeTeamLineup
        : current.opponentTeamLineup;
    final team2Lineup = isTeam1Active
        ? current.opponentTeamLineup
        : current.activeTeamLineup;

    return GameStateLineupSelection(
      match: updatedMatch,
      team1SelectedIds: _playerIds(team1Lineup),
      team2SelectedIds: _playerIds(team2Lineup),
    );
  }
}
