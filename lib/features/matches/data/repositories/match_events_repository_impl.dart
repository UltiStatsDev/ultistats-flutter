import 'package:ultistats/features/matches/data/models/create_event_request.dart';
import 'package:ultistats/features/matches/data/models/update_event_request.dart';
import 'package:ultistats/features/matches/data/sources/match_events_api.dart';
import 'package:ultistats/features/matches/domain/entities/match_event.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/domain/params/update_event_params.dart';
import 'package:ultistats/features/matches/domain/repositories/match_events_repository.dart';

class MatchEventsRepositoryImpl implements MatchEventsRepository {
  final MatchEventsApi _api;

  MatchEventsRepositoryImpl(this._api);

  @override
  Future<List<MatchEvent>> getEvents(String matchId) async {
    final models = await _api.getMatchEvents(matchId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addEvent(CreateEventParams params) async {
    final request = CreateEventRequest.fromParams(params);
    await _api.createMatchEvent(params.matchId, request);
  }

  @override
  Future<void> updateEvent(UpdateEventParams params) async {
    final request = UpdateEventRequest.fromParams(params);
    await _api.updateMatchEvent(params.matchId, params.index, request);
  }

  @override
  Future<void> deleteEvent(String matchId, int index) async {
    await _api.deleteMatchEvent(matchId, index);
  }
}
