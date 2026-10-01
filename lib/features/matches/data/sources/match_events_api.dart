import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ultistats/features/matches/data/models/event_model.dart';
import 'package:ultistats/features/matches/data/requests/update_event_request.dart';

part 'match_events_api.g.dart';

@RestApi()
abstract class EventsApi {
  factory EventsApi(Dio dio, {String baseUrl}) = _EventsApi;

  @GET('/matches/{matchId}/events')
  Future<List<EventModel>> getEvents(@Path('matchId') String matchId);

  @POST('/matches/{matchId}/events')
  Future<EventModel> createEvent(
    @Path('matchId') String matchId,
    @Body() EventModel body,
  );

  @GET('/matches/{matchId}/events/{eventId}')
  Future<EventModel> getEvent(
    @Path('matchId') String matchId,
    @Path('eventId') String eventId,
  );

  @PATCH('/matches/{matchId}/events/{eventId}')
  Future<EventModel> updateEvent(
    @Path('matchId') String matchId,
    @Path('eventId') String eventId,
    @Body() UpdateEventRequest body,
  );

  @DELETE('/matches/{matchId}/events/{eventId}')
  Future<void> deleteEvent(
    @Path('matchId') String matchId,
    @Path('eventId') String eventId,
  );
}
