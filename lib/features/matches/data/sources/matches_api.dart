import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ultistats/core/data/models/page_model.dart';
import 'package:ultistats/features/matches/data/models/match_model.dart';
import 'package:ultistats/features/matches/data/models/create_match_request.dart';
import 'package:ultistats/features/matches/data/models/match_filter_request.dart';
import 'package:ultistats/features/matches/data/models/match_timestamp_request.dart';
import 'package:ultistats/features/matches/data/models/update_match_request.dart';

part 'matches_api.g.dart';

@RestApi()
abstract class MatchesApi {
  factory MatchesApi(Dio dio, {String baseUrl}) = _MatchesApi;

  @GET('/api/v1/matches')
  Future<PageModel<MatchModel>> getMatches(@Queries() MatchFilterRequest queries);

  @POST('/api/v1/matches')
  Future<MatchModel> createMatch(@Body() CreateMatchRequest body);

  @GET('/api/v1/matches/{id}')
  Future<MatchModel> getMatchById(@Path('id') String id);

  @PUT('/api/v1/matches/{id}')
  Future<MatchModel> updateMatch(
    @Path('id') String id,
    @Body() UpdateMatchRequest body,
  );

  @DELETE('/api/v1/matches/{id}')
  Future<void> deleteMatch(@Path('id') String id);

  @POST('/api/v1/matches/{id}/start')
  Future<MatchModel> startMatch(
    @Path('id') String id,
    @Body() MatchTimestampRequest body,
  );

  @POST('/api/v1/matches/{id}/end')
  Future<MatchModel> endMatch(
    @Path('id') String id,
    @Body() MatchTimestampRequest body,
  );
}
