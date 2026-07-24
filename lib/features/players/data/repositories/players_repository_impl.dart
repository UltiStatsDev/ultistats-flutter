import 'package:dio/dio.dart';
import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/players/data/sources/players_api.dart';
import 'package:ultistats/features/players/domain/entities/player_list_item.dart';
import 'package:ultistats/features/players/domain/entities/player_detail.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';
import 'package:ultistats/features/players/domain/repositories/players_repository.dart';
import 'package:ultistats/features/players/data/models/player_filter_request.dart';
import 'package:ultistats/features/players/data/models/create_player_request.dart';
import 'package:ultistats/features/players/data/models/update_player_request.dart';

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
  Future<PlayerDetail> createPlayer(CreatePlayerParams params) async {
    final body = CreatePlayerRequest(
      firstName: params.firstName,
      lastName: params.lastName,
      number: params.number,
      teamId: params.teamId,
    );
    final result = await _api.createPlayer(body);
    return result.toEntity();
  }

  @override
  Future<void> deleteById(String playerId) async {
    await _api.deletePlayer(playerId);
  }

  @override
  Future<PlayerDetail> getById(String playerId) async {
    final result = await _api.getPlayerById(playerId);
    return result.toEntity();
  }

  @override
  Future<PlayerDetail> updateById(UpdatePlayerParams params) async {
    final body = UpdatePlayerRequest.fromParams(params);
    final result = await _api.updatePlayer(params.playerId, body);
    return result.toEntity();
  }

  @override
  Future<void> deletePlayerPhoto(String playerId) async {
    await _api.deletePlayerPhoto(playerId);
  }

  @override
  Future<String?> getPlayerPhotoUrl(String playerId) async {
    final result = await _api.getPlayerPhotoUrl(playerId);
    return result.url;
  }

  @override
  Future<String?> uploadPlayerPhoto(
    String playerId,
    List<int> bytes,
    String filename,
  ) async {
    final file = MultipartFile.fromBytes(bytes, filename: filename);
    final result = await _api.uploadPlayerPhoto(playerId, file);
    return result.url;
  }
}
