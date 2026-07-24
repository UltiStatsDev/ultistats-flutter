import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/players/domain/entities/player_list_item.dart';
import 'package:ultistats/features/players/domain/entities/player_detail.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';

abstract interface class PlayersRepository {
  Future<PlayerDetail> getById(String playerId);

  Future<PlayerDetail> updateById(UpdatePlayerParams params);

  Future<void> deleteById(String playerId);

  Future<Page<PlayerListItem>> getList(PlayerFilterParams params);

  Future<PlayerDetail> createPlayer(CreatePlayerParams params);

  Future<String?> getPlayerPhotoUrl(String playerId);

  Future<String?> uploadPlayerPhoto(
    String playerId,
    List<int> bytes,
    String filename,
  );

  Future<void> deletePlayerPhoto(String playerId);
}
