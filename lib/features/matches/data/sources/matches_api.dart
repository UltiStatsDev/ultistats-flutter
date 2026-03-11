import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ultistats/core/data/models/page_model.dart';
import 'package:ultistats/features/matches/data/models/match_model.dart';
import 'package:ultistats/features/matches/data/models/create_match_request.dart';
import 'package:ultistats/features/matches/data/models/match_filter_request.dart';
import 'package:ultistats/features/matches/data/models/match_timestamp_request.dart';

part 'matches_api.g.dart';

@RestApi()
abstract class MatchesApi {
  factory MatchesApi(Dio dio, {String baseUrl}) = _MatchesApi;

  // Matches
  @GET('/api/v1/matches')
  Future<PageModel<MatchModel>> getMatches(@Queries() MatchFilterRequest queries);

  @POST('/api/v1/matches')
  Future<MatchModel> createMatch(@Body() CreateMatchRequest body);

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

  @GET('/api/v1/matches/{id}')
  Future<MatchModel> getMatchById(@Path('id') String id);

  @DELETE('/api/v1/matches/{id}')
  Future<void> deleteMatch(@Path('id') String id);

  // // Events
  // @GET('/api/v1/matches/{matchId}/events')
  // Future<List<Map<String, dynamic>>> getMatchEvents(@Path('matchId') String matchId);
  //
  // @POST('/api/v1/matches/{matchId}/events')
  // Future<EventResponseModel> createMatchEvent(
  //   @Path('matchId') String matchId,
  //   @Body() Map<String, dynamic> body,
  // );
  //
  // @PUT('/api/v1/matches/{matchId}/events/{index}')
  // Future<EventResponseModel> updateMatchEvent(
  //   @Path('matchId') String matchId,
  //   @Path('index') int index,
  //   @Body() Map<String, dynamic> body,
  // );
  //
  // @DELETE('/api/v1/matches/{matchId}/events/{index}')
  // Future<EventResponseModel> deleteMatchEvent(
  //   @Path('matchId') String matchId,
  //   @Path('index') int index,
  // );
  //
  // // Statistics
  // @GET('/api/v1/matches/{matchId}/statistics')
  // Future<Map<String, dynamic>> getMatchStatistics(@Path('matchId') String matchId);
}
