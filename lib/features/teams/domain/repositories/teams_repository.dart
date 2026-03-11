import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/teams/domain/entities/team.dart';
import 'package:ultistats/features/teams/domain/params/create_team_params.dart';
import 'package:ultistats/features/teams/domain/params/team_filter_params.dart';
import 'package:ultistats/features/teams/domain/params/update_team_params.dart';

abstract interface class TeamsRepository {
  Future<Team> getById(String teamId);

  Future<Team> updateById(UpdateTeamParams params);

  Future<void> deleteById(String teamId);

  Future<Page<Team>> getList(TeamFilterParams params);

  Future<Team> createTeam(CreateTeamParams params);

  Future<Team> addPlayerToTeam(String teamId, String playerId);

  Future<Team> removePlayerFromTeam(String teamId, String playerId);
}
