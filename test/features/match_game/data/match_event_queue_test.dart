import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/features/match_game/data/match_event_queue.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/domain/params/update_event_params.dart';
import 'package:ultistats/features/matches/domain/repositories/match_events_repository.dart';

void main() {
  group('MatchEventQueue', () {
    test('отправляет события одного матча строго по порядку', () async {
      final started = <Event>[];
      final firstSend = Completer<void>();
      final repository = _FakeEventsRepository(
        onAdd: (params) async {
          started.add(params.event);
          if (started.length == 1) {
            await firstSend.future;
          }
        },
      );
      final queue = MatchEventQueue(repository);

      final first = Event1.pickup(participantId: 'p-1');
      final second = Event1.pickup(participantId: 'p-2');

      queue.enqueue('match-1', first);
      queue.enqueue('match-1', second);

      await Future<void>.delayed(Duration.zero);
      expect(started, [first]);
      expect(repository.added, isEmpty);

      firstSend.complete();
      await queue.drain('match-1');

      expect(started, [first, second]);
      expect(repository.added.map((params) => params.event), [first, second]);
    });

    test('разные матчи не блокируют друг друга', () async {
      final blockedSend = Completer<void>();
      final started = <String>[];
      final repository = _FakeEventsRepository(
        onAdd: (params) async {
          started.add(params.matchId);
          if (params.matchId == 'match-1') {
            await blockedSend.future;
          }
        },
      );
      final queue = MatchEventQueue(repository);

      queue.enqueue('match-1', Event1.pickup(participantId: 'p-1'));
      queue.enqueue('match-2', Event1.pickup(participantId: 'p-2'));

      await Future<void>.delayed(Duration.zero);
      expect(started, ['match-1', 'match-2']);

      blockedSend.complete();
      await queue.drain('match-1');
      await queue.drain('match-2');

      expect(repository.added.length, 2);
    });

    test('повторяет запрос при сетевой ошибке', () async {
      var attempts = 0;
      final repository = _FakeEventsRepository(
        onAdd: (_) async {
          attempts++;
          if (attempts == 1) {
            throw _networkError();
          }
        },
      );
      final queue = MatchEventQueue(
        repository,
        retryDelays: const [Duration.zero],
      );

      final event = Event1.pickup(participantId: 'p-1');
      queue.enqueue('match-1', event);
      await queue.drain('match-1');

      expect(attempts, 2);
      expect(repository.added.single.event, event);
    });

    test('повторяет запрос при 5xx', () async {
      var attempts = 0;
      final repository = _FakeEventsRepository(
        onAdd: (_) async {
          attempts++;
          if (attempts == 1) {
            throw _badResponse(500);
          }
        },
      );
      final queue = MatchEventQueue(
        repository,
        retryDelays: const [Duration.zero],
      );

      queue.enqueue('match-1', Event1.pickup(participantId: 'p-1'));
      await queue.drain('match-1');

      expect(attempts, 2);
    });

    test('не повторяет запрос при 4xx', () async {
      var attempts = 0;
      final repository = _FakeEventsRepository(
        onAdd: (_) async {
          attempts++;
          throw _badResponse(400);
        },
      );
      final queue = MatchEventQueue(
        repository,
        retryDelays: const [Duration.zero],
      );

      queue.enqueue('match-1', Event1.pickup(participantId: 'p-1'));
      await queue.drain('match-1');

      expect(attempts, 1);
      expect(repository.added, isEmpty);
    });

    test('drain на пустой очереди завершается сразу', () async {
      final queue = MatchEventQueue(_FakeEventsRepository());

      await expectLater(queue.drain('match-1'), completes);
    });
  });
}

class _FakeEventsRepository implements MatchEventsRepository {
  _FakeEventsRepository({this.onAdd});

  final Future<void> Function(CreateEventParams params)? onAdd;
  final List<CreateEventParams> added = [];

  @override
  Future<void> addEvent(CreateEventParams params) async {
    await onAdd?.call(params);
    added.add(params);
  }

  @override
  Future<List<Event>> getEvents(String matchId) async => const [];

  @override
  Future<void> updateEvent(UpdateEventParams params) async {}

  @override
  Future<void> deleteEvent(String matchId, String eventId) async {}
}

DioException _networkError() => DioException(
  requestOptions: RequestOptions(path: '/matches/match-1/events'),
  type: DioExceptionType.connectionError,
);

DioException _badResponse(int statusCode) {
  final options = RequestOptions(path: '/matches/match-1/events');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<void>(requestOptions: options, statusCode: statusCode),
  );
}
