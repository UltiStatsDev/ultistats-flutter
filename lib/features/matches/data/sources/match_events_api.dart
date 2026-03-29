import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ultistats/features/matches/data/models/match_event_model.dart';
import 'package:ultistats/features/matches/data/models/create_event_request.dart';
import 'package:ultistats/features/matches/data/models/update_event_request.dart';
import 'package:ultistats/features/matches/data/models/event_response_model.dart';

part 'match_events_api.g.dart';

@RestApi()
abstract class MatchEventsApi {
  factory MatchEventsApi(Dio dio, {String baseUrl}) = _MatchEventsApi;

  @GET('/api/v1/matches/{matchId}/events')
  Future<List<MatchEventModel>> getMatchEvents(@Path('matchId') String matchId);

  @POST('/api/v1/matches/{matchId}/events')
  Future<EventResponseModel> createMatchEvent(
    @Path('matchId') String matchId,
    @Body() CreateEventRequest body,
  );

  @PUT('/api/v1/matches/{matchId}/events/{index}')
  Future<EventResponseModel> updateMatchEvent(
    @Path('matchId') String matchId,
    @Path('index') int index,
    @Body() UpdateEventRequest body,
  );

  @DELETE('/api/v1/matches/{matchId}/events/{index}')
  Future<EventResponseModel> deleteMatchEvent(
    @Path('matchId') String matchId,
    @Path('index') int index,
  );
}
