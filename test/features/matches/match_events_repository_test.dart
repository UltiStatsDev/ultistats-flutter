import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/features/matches/data/repositories/match_events_repository_impl.dart';
import 'package:ultistats/features/matches/data/sources/match_events_api.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';

void main() {
  test(
    'creation preserves response identity without sending it in request',
    () async {
      final adapter = RecordingAdapter(200);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'))
        ..httpClientAdapter = adapter;
      addTearDown(() => dio.close(force: true));
      final repository = MatchEventsRepositoryImpl(EventsApi(dio));
      final stored = await repository.addEvent(
        CreateEventParams(
          matchId: 'match-1',
          event: Event2(
            id: 'response-only',
            sequenceNumber: 99,
            occurredAt: DateTime.utc(2026, 10, 24, 10),
            type: EventType.GOAL,
            participantId: 'player-1',
            toParticipantId: 'player-2',
          ),
        ),
      );
      expect(stored.id, 'event-3');
      expect(stored.sequenceNumber, 3);
      expect(
        adapter.requests.single.uri.path,
        '/api/v1/matches/match-1/events',
      );
      expect(adapter.requests.single.data, {
        'occurredAt': '2026-10-24T10:00:00.000Z',
        'type': 'GOAL',
        'fromParticipantId': 'player-1',
        'toParticipantId': 'player-2',
      });
    },
  );
  test(
    'undo sends one bodyless POST and preserves server event identity',
    () async {
      final adapter = RecordingAdapter(200);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'))
        ..httpClientAdapter = adapter;
      final repository = MatchEventsRepositoryImpl(EventsApi(dio));

      final event = await repository.undoLastEvent('match-1');

      expect(adapter.requests, hasLength(1));
      expect(adapter.requests.single.method, 'POST');
      expect(
        adapter.requests.single.uri.path,
        '/api/v1/matches/match-1/events/undo',
      );
      expect(adapter.requests.single.data, isNull);
      expect(event.id, 'event-3');
      expect(event.sequenceNumber, 3);
      expect(event.type, EventType.GOAL);
      expect((event as Event2).participantId, 'player-1');
      expect(event.toParticipantId, 'player-2');
    },
  );

  for (final status in [404, 409, 500]) {
    test('undo propagates $status without retrying', () async {
      final adapter = RecordingAdapter(status);
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'))
        ..httpClientAdapter = adapter;
      final repository = MatchEventsRepositoryImpl(EventsApi(dio));
      await expectLater(
        repository.undoLastEvent('match-1'),
        throwsA(isA<DioException>()),
      );
      expect(adapter.requests, hasLength(1));
    });
  }
}

class RecordingAdapter implements HttpClientAdapter {
  RecordingAdapter(this.status);
  final int status;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      status == 200
          ? '{"id":"event-3","sequenceNumber":3,"type":"GOAL","occurredAt":"2026-10-24T10:00:00Z","fromParticipantId":"player-1","toParticipantId":"player-2"}'
          : '{"status":$status,"detail":"Undo rejected"}',
      status,
      headers: {
        Headers.contentTypeHeader: [
          status == 200 ? 'application/json' : 'application/problem+json',
        ],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
