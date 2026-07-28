import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/teams/domain/entities/team_detail.dart';
import 'package:ultistats/features/teams/domain/entities/team_list_item.dart';
import 'package:ultistats/features/teams/domain/params/create_team_params.dart';
import 'package:ultistats/features/teams/domain/params/team_filter_params.dart';
import 'package:ultistats/features/teams/domain/params/update_team_params.dart';

abstract interface class TeamsRepository {
  Future<TeamDetail> getById(String teamId);

  Future<TeamDetail> updateById(UpdateTeamParams params);

  Future<void> deleteById(String teamId);

  Future<Page<TeamListItem>> getList(TeamFilterParams params);

  Future<TeamDetail> createTeam(CreateTeamParams params);

  Future<void> addOrUpdatePlayerInTeam(String teamId, String playerId, int number);

  Future<void> removePlayerFromTeam(String teamId, String playerId);

  Future<String?> getTeamPhotoUrl(String teamId);

  Future<String?> uploadTeamPhoto(
    String teamId,
    List<int> bytes,
    String filename,
  );

  Future<void> deleteTeamPhoto(String teamId);
}
