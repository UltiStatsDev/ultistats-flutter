import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';

sealed class MatchGameState {
  const MatchGameState();
}

class GameStateError extends MatchGameState {
  final String message;
  final Exception exception;
  final StackTrace stackTrace;

  const GameStateError(this.message, this.exception, this.stackTrace);
}

class GameStateLineupSelection extends MatchGameState {
  final MatchDetail match;
  final Set<String> team1SelectedIds;
  final Set<String> team2SelectedIds;

  const GameStateLineupSelection({
    required this.match,
    this.team1SelectedIds = const {},
    this.team2SelectedIds = const {},
  });

  GameStateLineupSelection copyWith({
    Set<String>? team1SelectedIds,
    Set<String>? team2SelectedIds,
  }) {
    return GameStateLineupSelection(
      match: match,
      team1SelectedIds: team1SelectedIds ?? this.team1SelectedIds,
      team2SelectedIds: team2SelectedIds ?? this.team2SelectedIds,
    );
  }
}

abstract class GameStateWithLineup extends MatchGameState {
  final MatchDetail match;

  final MatchTeam activeTeam;
  final List<MatchParticipant> activeTeamLineup;

  final MatchTeam opponentTeam;
  final List<MatchParticipant> opponentTeamLineup;

  const GameStateWithLineup({
    required this.match,
    required this.activeTeam,
    required this.activeTeamLineup,
    required this.opponentTeam,
    required this.opponentTeamLineup,
  });
}

class GameStatePullerSelection extends GameStateWithLineup {
  const GameStatePullerSelection({
    required super.match,
    required super.activeTeam,
    required super.activeTeamLineup,
    required super.opponentTeam,
    required super.opponentTeamLineup,
  });
}

class GameStateTakerSelection extends GameStateWithLineup {
  const GameStateTakerSelection({
    required super.match,
    required super.activeTeam,
    required super.activeTeamLineup,
    required super.opponentTeam,
    required super.opponentTeamLineup,
  });
}

class GameStatePlaying extends GameStateWithLineup {
  final MatchParticipant currentThrower;

  const GameStatePlaying({
    required super.match,
    required super.activeTeam,
    required super.activeTeamLineup,
    required super.opponentTeam,
    required super.opponentTeamLineup,
    required this.currentThrower,
  });
}
