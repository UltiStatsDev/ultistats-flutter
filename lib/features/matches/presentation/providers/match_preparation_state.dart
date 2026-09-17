import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/teams/domain/entities/team_detail.dart';

sealed class MatchPreparationState {
  const MatchPreparationState();
}

class MatchPreparationLoading extends MatchPreparationState {
  const MatchPreparationLoading();
}

class MatchPreparationLoaded extends MatchPreparationState {
  final MatchDetail match;
  final TeamDetail team1;
  final TeamDetail team2;
  final Set<String> selectedPlayerIds1;
  final Set<String> selectedPlayerIds2;
  final bool isStarting;
  final bool isSuccess;

  const MatchPreparationLoaded({
    required this.match,
    required this.team1,
    required this.team2,
    this.selectedPlayerIds1 = const {},
    this.selectedPlayerIds2 = const {},
    this.isStarting = false,
    this.isSuccess = false,
  });

  bool get canStart =>
      selectedPlayerIds1.length == 5 && selectedPlayerIds2.length == 5;

  PreparationWarning? get team1Warning {
    if (team1.players.length < 5) return PreparationWarning.needs5players;
    if (selectedPlayerIds1.length != 5) return PreparationWarning.select5players;
    return null;
  }

  PreparationWarning? get team2Warning {
    if (team2.players.length < 5) return PreparationWarning.needs5players;
    if (selectedPlayerIds2.length != 5) return PreparationWarning.select5players;
    return null;
  }

  MatchPreparationLoaded copyWith({
    Set<String>? selectedPlayerIds1,
    Set<String>? selectedPlayerIds2,
    bool? isStarting,
    bool? isSuccess,
  }) {
    return MatchPreparationLoaded(
      match: match,
      team1: team1,
      team2: team2,
      selectedPlayerIds1: selectedPlayerIds1 ?? this.selectedPlayerIds1,
      selectedPlayerIds2: selectedPlayerIds2 ?? this.selectedPlayerIds2,
      isStarting: isStarting ?? this.isStarting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class MatchPreparationError extends MatchPreparationState {
  final Object error;
  final StackTrace stackTrace;

  const MatchPreparationError(this.error, this.stackTrace);
}

enum PreparationWarning {
  needs5players,
  select5players,
}
