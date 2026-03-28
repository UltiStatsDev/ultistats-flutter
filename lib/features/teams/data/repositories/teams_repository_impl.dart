
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

  // Фейковые команды для тестирования пагинации
  static final List<Team> _allFakeTeams = _generateFakeTeams();

  static List<Team> _generateFakeTeams() {
    const teamNames = [
      'Sky Pro',
      'Ultimate Warriors',
      'Disk Catchers',
      'Wind Walkers',
      'Flyers United',
      'Storm Bringers',
      'Thunder Birds',
      'Flying Discs',
      'Air Force',
      'Gravity Defiers',
      'Disc Masters',
      'Speed Demons',
      'Wind Riders',
      'Sky Hunters',
      'Flash Point',
      'Storm Chasers',
      'Night Hawks',
      'Phoenix Rising',
      'Blue Thunder',
      'Red Dragons',
      'Golden Eagles',
      'Silver Wolves',
      'Dark Knights',
      'Wild Cards',
      'Fast Break',
      'Power Play',
      'Top Spin',
      'Full Flight',
      'End Zone',
      'Breakaway',
      'Huck It',
      'Stack Attack',
      'Zone Defense',
      'Deep Cut',
      'Handler Crew',
      'Layout Kings',
      'Sky Strike',
      'Disc Golf Pros',
      'Ultimate Legends',
      'Prime Time',
      'All Stars',
      'Dream Team',
      'Elite Force',
      'Championship',
      'Victory Squad',
      'Winning Edge',
      'Top Tier',
      'First Class',
      'Premium Plus',
      'Super Stars',
    ];

    return List.generate(
      teamNames.length,
      (i) => Team(id: '${i + 1}', name: teamNames[i], players: []),
    );
  }

  @override
  Future<Page<Team>> getList(TeamFilterParams params) async {
    await Future.delayed(Duration(seconds: 1));
    final request = TeamFilterRequest.fromParams(params);
    final pageModel = await _api.getTeams(request);
    return Page<Team>(
      content: pageModel.content.map((m) => m.toEntity()).toList(),
      totalElements: pageModel.totalElements,
      totalPages: pageModel.totalPages,
      currentPage: pageModel.currentPage,
      size: pageModel.size,
    );

    // Фейковая загрузка с задержкой
    // await Future.delayed(const Duration(milliseconds: 800));
    //
    // final allTeams = _allFakeTeams;
    // final totalElements = allTeams.length;
    // final totalPages = (totalElements / params.size).ceil();
    // final startIndex = params.page * params.size;
    // final endIndex = (startIndex + params.size).clamp(0, totalElements);
    //
    // final pageContent =
    //     startIndex < totalElements ? allTeams.sublist(startIndex, endIndex) : <Team>[];
    //
    // return Page<Team>(
    //   content: pageContent,
    //   totalElements: totalElements,
    //   totalPages: totalPages,
    //   currentPage: params.page,
    //   size: params.size,
    // );
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
}
