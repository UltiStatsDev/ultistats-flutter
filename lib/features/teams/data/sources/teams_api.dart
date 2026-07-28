import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ultistats/core/data/models/page_model.dart';
import 'package:ultistats/features/teams/data/models/team_detail_model.dart';
import 'package:ultistats/features/teams/data/models/team_list_item_model.dart';
import 'package:ultistats/features/teams/data/models/create_team_request.dart';
import 'package:ultistats/features/teams/data/models/update_team_request.dart';
import 'package:ultistats/features/teams/data/models/team_filter_request.dart';
import 'package:ultistats/features/teams/data/models/upsert_team_player_request.dart';
import 'package:ultistats/features/players/data/models/player_membership_model.dart';
import 'package:ultistats/core/data/models/photo_url_response.dart';

part 'teams_api.g.dart';

@RestApi()
abstract class TeamsApi {
  factory TeamsApi(Dio dio, {String baseUrl}) = _TeamsApi;

  @GET('/teams') //+
  Future<PageModel<TeamListItemModel>> getTeams(
    @Queries() TeamFilterRequest queries,
  );

  @GET('/teams/{id}') //+
  Future<TeamDetailModel> getTeamById(@Path('id') String id);

  @POST('/teams') //+
  Future<TeamDetailModel> createTeam(@Body() CreateTeamRequest body);

  @PUT('/teams/{id}') //+
  Future<TeamDetailModel> updateTeam(
    @Path('id') String id,
    @Body() UpdateTeamRequest body,
  );

  @DELETE('/teams/{id}') //+
  Future<void> deleteTeam(@Path('id') String id);

  @PUT('/teams/{teamId}/players/{playerId}') //+
  Future<PlayerMembershipModel> addOrUpdatePlayerInTeam(
    @Path('teamId') String teamId,
    @Path('playerId') String playerId,
    @Body() UpsertTeamPlayerRequest body,
  );

  @DELETE('/teams/{teamId}/players/{playerId}') //+
  Future<void> removePlayerFromTeam(
    @Path('teamId') String teamId,
    @Path('playerId') String playerId,
  );

  @GET('/teams/{teamId}/players') //+
  Future<List<PlayerMembershipModel>> getTeamRoster(@Path('teamId') String teamId);

  @GET('/teams/{teamId}/photoUrl') //+
  Future<PhotoUrlResponse> getTeamPhotoUrl(@Path('teamId') String teamId);

  @POST('/teams/{teamId}/uploadPhoto') //+
  @MultiPart()
  Future<PhotoUrlResponse> uploadTeamPhoto(
    @Path('teamId') String teamId,
    @Part(name: 'multipartFile') MultipartFile multipartFile,
  );

  @DELETE('/teams/{teamId}/photoUrl') //+
  Future<PhotoUrlResponse> deleteTeamPhoto(@Path('teamId') String teamId);
}
