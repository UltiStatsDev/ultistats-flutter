import 'package:ultistats/features/players/domain/entities/player_detail.dart';
import 'package:ultistats/features/teams/domain/entities/team_detail.dart';

sealed class PlayerDetailState {
  const PlayerDetailState();
}

class PlayerDetailInitial extends PlayerDetailState {
  const PlayerDetailInitial();
}

class PlayerDetailLoading extends PlayerDetailState {
  const PlayerDetailLoading();
}

class PlayerDetailLoaded extends PlayerDetailState {
  final PlayerDetail player;
  final List<TeamDetail> teamMemberships;

  const PlayerDetailLoaded(this.player, this.teamMemberships);
}

class PlayerDetailError extends PlayerDetailState {
  final Object error;
  final StackTrace stackTrace;

  const PlayerDetailError(this.error, this.stackTrace);
}
