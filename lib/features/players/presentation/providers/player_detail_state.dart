import 'package:ultistats/features/players/domain/entities/player_detail.dart';

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

  const PlayerDetailLoaded(this.player);
}

class PlayerDetailError extends PlayerDetailState {
  final Object error;
  final StackTrace stackTrace;

  const PlayerDetailError(this.error, this.stackTrace);
}
