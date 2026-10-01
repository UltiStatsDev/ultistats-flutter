import 'package:ultistats/features/teams/domain/entities/team_detail.dart';

sealed class TeamDetailState {
  const TeamDetailState();
}

class TeamDetailInitial extends TeamDetailState {
  const TeamDetailInitial();
}

class TeamDetailLoading extends TeamDetailState {
  const TeamDetailLoading();
}

class TeamDetailLoaded extends TeamDetailState {
  final TeamDetail team;
  final Set<String> processingPlayerIds;

  const TeamDetailLoaded(
    this.team, {
    this.processingPlayerIds = const {},
  });

  TeamDetailLoaded copyWith({
    TeamDetail? team,
    Set<String>? processingPlayerIds,
  }) {
    return TeamDetailLoaded(
      team ?? this.team,
      processingPlayerIds: processingPlayerIds ?? this.processingPlayerIds,
    );
  }
}

class TeamDetailError extends TeamDetailState {
  final Object error;
  final StackTrace stackTrace;

  const TeamDetailError(this.error, this.stackTrace);
}
