import 'package:ultistats/features/players/domain/entities/player_detail.dart';
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

  const TeamDetailLoaded(this.team);
}

class TeamDetailError extends TeamDetailState {
  final Object error;
  final StackTrace stackTrace;

  const TeamDetailError(this.error, this.stackTrace);
}
