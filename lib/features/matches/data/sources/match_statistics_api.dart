import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ultistats/features/matches/data/models/match_statistics_model.dart';

part 'match_statistics_api.g.dart';

@RestApi()
abstract class MatchStatisticsApi {
  factory MatchStatisticsApi(Dio dio, {String baseUrl}) = _MatchStatisticsApi;

  @GET('/api/v1/matches/{matchId}/statistics')
  Future<MatchStatisticsModel> getMatchStatistics(@Path('matchId') String matchId);
}
