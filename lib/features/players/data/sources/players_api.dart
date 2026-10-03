import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ultistats/core/data/models/page_model.dart';
import 'package:ultistats/features/players/data/models/player_list_item_model.dart';
import 'package:ultistats/features/players/data/models/player_detail_model.dart';
import 'package:ultistats/features/players/data/requests/create_player_request.dart';
import 'package:ultistats/features/players/data/models/player_membership_model.dart';
import 'package:ultistats/core/data/models/photo_url_response.dart';
import 'package:ultistats/features/players/data/requests/player_filter_request.dart';
import 'package:ultistats/features/players/data/requests/update_player_request.dart';

part 'players_api.g.dart';

@RestApi()
abstract class PlayersApi {
  factory PlayersApi(Dio dio, {String baseUrl}) = _PlayersApi;

  @GET('/players')
  Future<PageModel<PlayerListItemModel>> getPlayers(
    @Queries() PlayerFilterRequest queries,
  );

  @POST('/players')
  Future<PlayerDetailModel> createPlayer(@Body() CreatePlayerRequest body);

  @GET('/players/{id}')
  Future<PlayerDetailModel> getPlayerById(@Path('id') String id);

  @PUT('/players/{id}')
  Future<PlayerDetailModel> updatePlayer(
    @Path('id') String id,
    @Body() UpdatePlayerRequest body,
  );

  @DELETE('/players/{id}')
  Future<void> deletePlayer(@Path('id') String id);

  @GET('/players/{playerId}/teams')
  Future<List<PlayerMembershipModel>> getPlayerTeams(
    @Path('playerId') String playerId,
  );

  @GET('/players/{playerId}/photo')
  Future<PhotoUrlResponse> getPlayerPhotoUrl(@Path('playerId') String playerId);

  @PUT('/players/{playerId}/photo')
  @MultiPart()
  Future<PhotoUrlResponse> uploadPlayerPhoto(
    @Path('playerId') String playerId,
    @Part(name: 'multipartFile') MultipartFile multipartFile,
  );

  @DELETE('/players/{playerId}/photo')
  Future<PhotoUrlResponse> deletePlayerPhoto(@Path('playerId') String playerId);
}
