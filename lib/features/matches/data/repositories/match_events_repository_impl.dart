import 'package:ultistats/features/matches/data/models/event_model.dart';
import 'package:ultistats/features/matches/data/requests/update_event_request.dart';
import 'package:ultistats/features/matches/data/sources/match_events_api.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/domain/params/update_event_params.dart';
import 'package:ultistats/features/matches/domain/repositories/match_events_repository.dart';

class MatchEventsRepositoryImpl implements MatchEventsRepository {
  final EventsApi _api;

  MatchEventsRepositoryImpl(this._api);

  @override
  Future<List<Event>> getEvents(String matchId) async {
    final models = await _api.getEvents(matchId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addEvent(CreateEventParams params) async {
    await _api.createEvent(params.matchId, EventModel.fromEntity(params.event));
  }

  @override
  Future<void> updateEvent(UpdateEventParams params) async {
    final request = UpdateEventRequest.fromParams(params);
    await _api.updateEvent(params.matchId, params.eventId, request);
  }

  @override
  Future<void> deleteEvent(String matchId, String eventId) async {
    await _api.deleteEvent(matchId, eventId);
  }
}
