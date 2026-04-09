import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/teams/data/models/create_team_request.dart';
import 'package:ultistats/features/teams/data/models/update_team_request.dart';
import 'package:ultistats/features/teams/data/models/team_filter_request.dart';
import 'package:ultistats/features/teams/data/sources/teams_api.dart';
import 'package:ultistats/features/teams/domain/entities/team.dart';
import 'package:ultistats/features/teams/domain/params/create_team_params.dart';
import 'package:ultistats/features/teams/domain/params/team_filter_params.dart';
import 'package:ultistats/features/teams/domain/params/update_team_params.dart';
import 'package:ultistats/features/teams/domain/repositories/teams_repository.dart';

class TeamsRepositoryImpl implements TeamsRepository {
  final TeamsApi _api;

  TeamsRepositoryImpl(this._api);

  @override
  Future<Team> createTeam(CreateTeamParams params) async {
    final request = CreateTeamRequest.fromParams(params);
    final model = await _api.createTeam(request);
    return model.toEntity();
  }

  @override
  Future<void> deleteById(String teamId) {
    return _api.deleteTeam(teamId);
  }

  @override
  Future<Team> getById(String teamId) async {
    final model = await _api.getTeamById(teamId);
    return model.toEntity();
  }

  @override
  Future<Page<Team>> getList(TeamFilterParams params) async {

    await Future.delayed(Duration(seconds: 5));

    final request = TeamFilterRequest.fromParams(params);
    final pageModel = await _api.getTeams(request);
    return Page<Team>(
      content: pageModel.content.map((m) => m.toEntity()).toList(),
      totalElements: pageModel.totalElements,
      totalPages: pageModel.totalPages,
      currentPage: pageModel.currentPage,
      size: pageModel.size,
    );
  }

  @override
  Future<Team> updateById(UpdateTeamParams params) async {
    final request = UpdateTeamRequest.fromParams(params);
    final model = await _api.updateTeam(params.teamId, request);
    return model.toEntity();
  }

  @override
  Future<Team> addPlayerToTeam(String teamId, String playerId) async {
    final model = await _api.addPlayerToTeam(teamId, playerId);
    return model.toEntity();
  }

  @override
  Future<Team> removePlayerFromTeam(String teamId, String playerId) async {
    final model = await _api.removePlayerFromTeam(teamId, playerId);
    return model.toEntity();
  }

  @override
  Future<String?> getTeamPhotoUrl(String teamId) async {
    final response = await _api.getTeamPhotoUrl(teamId);
    return response.url;
  }

  @override
  Future<String?> uploadTeamPhoto(String teamId, List<int> bytes, String filename) async {
    final extension = filename.split('.').last.toLowerCase();
    final mimeType = switch (extension) {
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      _ => 'application/octet-stream',
    };

    final file = MultipartFile.fromBytes(
      bytes,
      filename: filename,
      contentType: MediaType.parse(mimeType),
    );
    final response = await _api.uploadTeamPhoto(teamId, file);
    return response.url;
  }

  @override
  Future<void> deleteTeamPhoto(String teamId) async {
    await _api.deleteTeamPhoto(teamId);
  }
}
