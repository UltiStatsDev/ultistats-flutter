import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ultistats/core/data/models/page_model.dart';
import 'package:ultistats/features/teams/data/models/team_model.dart';
import 'package:ultistats/features/teams/data/models/create_team_request.dart';
import 'package:ultistats/features/teams/data/models/update_team_request.dart';
import 'package:ultistats/features/teams/data/models/team_filter_request.dart';
import 'package:ultistats/features/teams/data/models/photo_url_response.dart';

part 'teams_api.g.dart';

@RestApi()
abstract class TeamsApi {
  factory TeamsApi(Dio dio, {String baseUrl}) = _TeamsApi;

  @GET('/teams/{id}')
  Future<TeamModel> getTeamById(@Path('id') String id);

  @PUT('/teams/{id}')
  Future<TeamModel> updateTeam(
    @Path('id') String id,
    @Body() UpdateTeamRequest body,
  );

  @DELETE('/teams/{id}')
  Future<void> deleteTeam(@Path('id') String id);

  @GET('/teams')
  Future<PageModel<TeamModel>> getTeams(@Queries() TeamFilterRequest queries);

  @POST('/teams')
  Future<TeamModel> createTeam(@Body() CreateTeamRequest body);

  @POST('/teams/{teamId}/players/{playerId}')
  Future<TeamModel> addPlayerToTeam(
    @Path('teamId') String teamId,
    @Path('playerId') String playerId,
  );

  @DELETE('/teams/{teamId}/players/{playerId}')
  Future<TeamModel> removePlayerFromTeam(
    @Path('teamId') String teamId,
    @Path('playerId') String playerId,
  );

  @GET('/teams/{teamId}/photoUrl')
  Future<PhotoUrlResponse> getTeamPhotoUrl(@Path('teamId') String teamId);

  @POST('/teams/{teamId}/uploadPhoto')
  @MultiPart()
  Future<PhotoUrlResponse> uploadTeamPhoto(
    @Path('teamId') String teamId,
    @Part(name: 'multipartFile') MultipartFile multipartFile,
  );

  @DELETE('/teams/{teamId}/photoUrl')
  Future<PhotoUrlResponse> deleteTeamPhoto(@Path('teamId') String teamId);
}
