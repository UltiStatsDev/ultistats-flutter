import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/players/data/models/create_player_request.dart';
import 'package:ultistats/features/players/data/models/update_player_request.dart';
import 'package:ultistats/features/players/data/models/player_filter_request.dart';
import 'package:ultistats/features/players/data/sources/players_api.dart';
import 'package:ultistats/features/players/domain/entities/player.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';
import 'package:ultistats/features/players/domain/repositories/players_repository.dart';

class PlayersRepositoryImpl implements PlayersRepository {
  final PlayersApi _api;

  PlayersRepositoryImpl(this._api);

  @override
  Future<Player> createPlayer(CreatePlayerParams params) async {
    final request = CreatePlayerRequest.fromParams(params);
    final model = await _api.createPlayer(request);
    return model.toEntity();
  }

  @override
  Future<void> deleteById(String playerId) {
    return _api.deletePlayer(playerId);
  }

  @override
  Future<Player> getById(String playerId) async {
    final model = await _api.getPlayerById(playerId);
    return model.toEntity();
  }

  @override
  Future<Page<Player>> getList(PlayerFilterParams params) async {
    final request = PlayerFilterRequest.fromParams(params);
    final pageModel = await _api.getPlayers(request);

    return Page<Player>(
      content: pageModel.content.map((m) => m.toEntity()).toList(),
      totalElements: pageModel.totalElements,
      totalPages: pageModel.totalPages,
      currentPage: pageModel.currentPage,
      size: pageModel.size,
    );
  }

  @override
  Future<Player> updateById(UpdatePlayerParams params) async {
    final request = UpdatePlayerRequest.fromParams(params);
    final model = await _api.updatePlayer(params.playerId, request);
    return model.toEntity();
  }
}
