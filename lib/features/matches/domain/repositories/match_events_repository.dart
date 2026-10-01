import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/domain/params/update_event_params.dart';

abstract interface class MatchEventsRepository {
  Future<List<Event>> getEvents(String matchId);

  Future<void> addEvent(CreateEventParams params);

  Future<void> updateEvent(UpdateEventParams params);

  Future<void> deleteEvent(String matchId, String eventId);
}
