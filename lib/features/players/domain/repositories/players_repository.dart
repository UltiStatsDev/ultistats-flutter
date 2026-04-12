import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/players/domain/entities/player_list_item.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';

abstract interface class PlayersRepository {
  Future<void> getById(String playerId);

  Future<void> updateById(UpdatePlayerParams params);

  Future<void> deleteById(String playerId);

  Future<Page<PlayerListItem>> getList(PlayerFilterParams params);

  Future<void> createPlayer(CreatePlayerParams params);
}
