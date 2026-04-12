import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/players/data/sources/players_api.dart';
import 'package:ultistats/features/players/domain/entities/player_list_item.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';
import 'package:ultistats/features/players/domain/repositories/players_repository.dart';
import 'package:ultistats/features/players/data/models/player_filter_request.dart';
import 'package:ultistats/features/players/data/models/create_player_request.dart';

class PlayersRepositoryImpl implements PlayersRepository {
  final PlayersApi _api;

  PlayersRepositoryImpl(this._api);

  @override
  Future<Page<PlayerListItem>> getList(PlayerFilterParams params) async {
    final request = PlayerFilterRequest(
      page: params.page,
      size: params.size,
      name: params.name,
      teamId: params.teamId,
      sort: params.sort,
    );

    final result = await _api.getPlayers(request);

    return Page(
      content: result.content.map((e) => e.toEntity()).toList(),
      totalElements: result.totalElements,
      totalPages: result.totalPages,
      currentPage: result.currentPage,
      size: result.size,
    );
  }

  @override
  Future<void> createPlayer(CreatePlayerParams params) async {
    final body = CreatePlayerRequest(
      firstName: params.firstName,
      lastName: params.lastName,
      number: params.number,
      teamId: params.teamId,
    );
    await _api.createPlayer(body);
  }

  @override
  Future<void> deleteById(String playerId) async {
    await _api.deletePlayer(playerId);
  }

  @override
  Future<void> getById(String playerId) async {
    await _api.getPlayerById(playerId);
  }

  @override
  Future<void> updateById(UpdatePlayerParams params) async {
    // TODO: Реализовать когда будет UpdatePlayerRequest
  }
}
