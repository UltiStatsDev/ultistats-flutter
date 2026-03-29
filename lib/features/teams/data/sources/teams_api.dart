import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ultistats/core/data/models/page_model.dart';
import 'package:ultistats/features/teams/data/models/team_model.dart';
import 'package:ultistats/features/teams/data/models/create_team_request.dart';
import 'package:ultistats/features/teams/data/models/update_team_request.dart';
import 'package:ultistats/features/teams/data/models/team_filter_request.dart';

part 'teams_api.g.dart';

@RestApi()
abstract class TeamsApi {
  factory TeamsApi(Dio dio, {String baseUrl}) = _TeamsApi;

  @GET('/api/v1/teams/{id}')
  Future<TeamModel> getTeamById(@Path('id') String id);

  @PUT('/api/v1/teams/{id}')
  Future<TeamModel> updateTeam(
    @Path('id') String id,
    @Body() UpdateTeamRequest body,
  );

  @DELETE('/api/v1/teams/{id}')
  Future<void> deleteTeam(@Path('id') String id);

  @GET('/api/v1/teams')
  Future<PageModel<TeamModel>> getTeams(@Queries() TeamFilterRequest queries);

  @POST('/api/v1/teams')
  Future<TeamModel> createTeam(@Body() CreateTeamRequest body);

  @POST('/api/v1/teams/{teamId}/players/{playerId}')
  Future<TeamModel> addPlayerToTeam(
    @Path('teamId') String teamId,
    @Path('playerId') String playerId,
  );

  @DELETE('/api/v1/teams/{teamId}/players/{playerId}')
  Future<TeamModel> removePlayerFromTeam(
    @Path('teamId') String teamId,
    @Path('playerId') String playerId,
  );

  @GET('/api/v1/teams/{id}/photo')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getTeamPhoto(@Path('id') String id);

  @POST('/api/v1/teams/{id}/photo')
  @MultiPart()
  Future<Map<String, String>> uploadTeamPhoto(
    @Path('id') String id,
    @Part(name: 'file') MultipartFile file,
  );

  @DELETE('/api/v1/teams/{id}/photo')
  Future<void> deleteTeamPhoto(@Path('id') String id);
}
