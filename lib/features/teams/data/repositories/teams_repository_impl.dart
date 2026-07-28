import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/teams/data/sources/teams_api.dart';
import 'package:ultistats/features/teams/domain/entities/team_detail.dart';
import 'package:ultistats/features/teams/domain/entities/team_list_item.dart';
import 'package:ultistats/features/teams/domain/params/create_team_params.dart';
import 'package:ultistats/features/teams/domain/params/team_filter_params.dart';
import 'package:ultistats/features/teams/domain/params/update_team_params.dart';
import 'package:ultistats/features/teams/domain/repositories/teams_repository.dart';
import 'package:ultistats/features/teams/data/models/team_filter_request.dart';
import 'package:ultistats/features/teams/data/models/create_team_request.dart';
import 'package:ultistats/features/teams/data/models/update_team_request.dart';
import 'package:ultistats/features/teams/data/models/upsert_team_player_request.dart';
import 'package:dio/dio.dart';

class TeamsRepositoryImpl implements TeamsRepository {
  final TeamsApi _api;

  TeamsRepositoryImpl(this._api);

  @override
  Future<Page<TeamListItem>> getList(TeamFilterParams params) async {
    final request = TeamFilterRequest(
      page: params.page,
      size: params.size,
      name: params.name,
      sort: params.sort,
    );

    final result = await _api.getTeams(request);

    return Page(
      content: result.content.map((e) => e.toEntity()).toList(),
      totalElements: result.totalElements,
      totalPages: result.totalPages,
      currentPage: result.currentPage,
      size: result.size,
    );
  }

  @override
  Future<TeamDetail> getById(String teamId) async {
    final result = await _api.getTeamById(teamId);
    return result.toEntity();
  }

  @override
  Future<TeamDetail> createTeam(CreateTeamParams params) async {
    final body = CreateTeamRequest(
      name: params.name,
      city: params.city,
    );
    final result = await _api.createTeam(body);
    return result.toEntity();
  }

  @override
  Future<TeamDetail> updateById(UpdateTeamParams params) async {
    final body = UpdateTeamRequest(
      name: params.name,
      city: params.city,
    );
    final result = await _api.updateTeam(params.teamId, body);
    return result.toEntity();
  }

  @override
  Future<void> deleteById(String teamId) async {
    await _api.deleteTeam(teamId);
  }

  @override
  Future<void> addOrUpdatePlayerInTeam(String teamId, String playerId, int number) async {
    await _api.addOrUpdatePlayerInTeam(
      teamId,
      playerId,
      UpsertTeamPlayerRequest(number: number),
    );
  }

  @override
  Future<void> removePlayerFromTeam(String teamId, String playerId) async {
    await _api.removePlayerFromTeam(teamId, playerId);
  }

  @override
  Future<String?> getTeamPhotoUrl(String teamId) async {
    final result = await _api.getTeamPhotoUrl(teamId);
    return result.url;
  }

  @override
  Future<String?> uploadTeamPhoto(
    String teamId,
    List<int> bytes,
    String filename,
  ) async {
    final file = MultipartFile.fromBytes(bytes, filename: filename);
    final result = await _api.uploadTeamPhoto(teamId, file);
    return result.url;
  }

  @override
  Future<void> deleteTeamPhoto(String teamId) async {
    await _api.deleteTeamPhoto(teamId);
  }
}
