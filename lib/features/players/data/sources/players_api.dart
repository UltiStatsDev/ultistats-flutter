import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ultistats/core/data/models/page_model.dart';
import 'package:ultistats/features/players/data/models/player_model.dart';
import 'package:ultistats/features/players/data/models/create_player_request.dart';
import 'package:ultistats/features/players/data/models/update_player_request.dart';
import 'package:ultistats/features/players/data/models/player_filter_request.dart';

part 'players_api.g.dart';

@RestApi()
abstract class PlayersApi {
  factory PlayersApi(Dio dio, {String baseUrl}) = _PlayersApi;

  @GET('/api/v1/players/{id}')
  Future<PlayerModel> getPlayerById(@Path('id') String id);

  @PUT('/api/v1/players/{id}')
  Future<PlayerModel> updatePlayer(
    @Path('id') String id,
    @Body() UpdatePlayerRequest body,
  );

  @DELETE('/api/v1/players/{id}')
  Future<void> deletePlayer(@Path('id') String id);

  @GET('/api/v1/players')
  Future<PageModel<PlayerModel>> getPlayers(@Queries() PlayerFilterRequest queries);

  @POST('/api/v1/players')
  Future<PlayerModel> createPlayer(@Body() CreatePlayerRequest body);
}
