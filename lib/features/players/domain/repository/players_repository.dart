import 'package:ultistats/core/entities/page.dart';
import 'package:ultistats/features/players/domain/entities/player.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';

abstract interface class PlayersRepository {
  Future<Player> getById(String playerId);

  Future<Player> updateById(UpdatePlayerParams params);

  Future<void> deleteById(String playerId);

  Future<Page<Player>> getList(PlayerFilterParams params);

  Future<Player> createPlayer(CreatePlayerParams params);
}
