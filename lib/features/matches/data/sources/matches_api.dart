import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ultistats/core/data/models/page_model.dart';
import 'package:ultistats/features/matches/data/models/match_detail_model.dart';
import 'package:ultistats/features/matches/data/models/match_list_item_model.dart';
import 'package:ultistats/features/matches/data/models/create_match_request.dart';
import 'package:ultistats/features/matches/data/models/match_filter_request.dart';
import 'package:ultistats/features/matches/data/models/match_timestamp_request.dart';
import 'package:ultistats/features/matches/data/models/update_match_request.dart';

part 'matches_api.g.dart';

@RestApi()
abstract class MatchesApi {
  factory MatchesApi(Dio dio, {String baseUrl}) = _MatchesApi;

  @GET('/matches')
  Future<PageModel<MatchListItemModel>> getMatches(
    @Queries() MatchFilterRequest queries,
  );

  @POST('/matches')
  Future<MatchDetailModel> createMatch(@Body() CreateMatchRequest body);

  @GET('/matches/{id}')
  Future<MatchDetailModel> getMatchById(@Path('id') String id);

  @PUT('/matches/{id}')
  Future<MatchDetailModel> updateMatch(
    @Path('id') String id,
    @Body() UpdateMatchRequest body,
  );

  @DELETE('/matches/{id}')
  Future<void> deleteMatch(@Path('id') String id);

  @POST('/matches/{id}/start')
  Future<MatchDetailModel> startMatch(
    @Path('id') String id,
    @Body() MatchTimestampRequest body,
  );

  @POST('/matches/{id}/end')
  Future<MatchDetailModel> endMatch(
    @Path('id') String id,
    @Body() MatchTimestampRequest body,
  );
}
