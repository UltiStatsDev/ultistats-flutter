import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/matches/data/models/event_model.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/domain/params/update_event_params.dart';
import 'package:ultistats/features/matches/domain/repositories/match_events_repository.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_state.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_timer_notifier.dart';

void main() {
  late GameHarness h;
  setUp(() async {
    h = GameHarness();
    await h.settle();
  });
  tearDown(() => h.container.dispose());

  test('undo is unavailable until this session records an event', () {
    expect(h.notifier.canUndo, isFalse);
  });

  test(
    'repeated undo restores goal score, thrower, pickup and pull selection',
    () async {
      await h.play();
      h.notifier.passTo(playerB2);
      await h.settle();
      h.notifier.scoreGoal(playerB1);
      await h.settle();
      expect(h.state.match.teams[1].score, 1);

      await h.notifier.undoLastEvent();
      expect(h.state.match.teams[1].score, 0);
      expect((h.state as GameStatePlaying).currentThrower.participantId, 'b2');
      await h.notifier.undoLastEvent();
      expect((h.state as GameStatePlaying).currentThrower.participantId, 'b1');
      await h.notifier.undoLastEvent();
      expect(h.state, isA<GameStateTakerSelection>());
      await h.notifier.undoLastEvent();
      expect((h.state as GameStatePullerSelection).activeTeam.id, 'team-a');
      expect(h.notifier.canUndo, isFalse);
      expect(h.repository.events, isEmpty);
    },
  );

  for (final change in ['delete', 'edit']) {
    test('earlier remote $change prevents stale snapshot restore', () async {
      await h.play();
      if (change == 'delete') {
        h.repository.events.removeAt(0);
      } else {
        final previous = h.repository.events.first;
        h.repository.events[0] = Event1(
          id: previous.id,
          sequenceNumber: previous.sequenceNumber,
          occurredAt: previous.occurredAt,
          type: EventType.PULL,
          participantId: 'a2',
        );
      }
      await h.notifier.undoLastEvent();
      expect(h.repository.undoCalls, 0);
      expect(h.notifier.needsSync, isTrue);
    });
  }

  test('undo turnover restores possession and selected lineups', () async {
    await h.play();
    h.notifier.turnover();
    await h.settle();
    expect((h.state as GameStateTakerSelection).activeTeam.id, 'team-a');
    await h.notifier.undoLastEvent();
    final state = h.state as GameStatePlaying;
    expect(state.activeTeam.id, 'team-b');
    expect(state.currentThrower.participantId, 'b1');
    expect(state.activeTeamLineup.map((p) => p.participantId), ['b1', 'b2']);
  });

  test(
    'pending create disables undo and ignores competing game input',
    () async {
      await h.play();
      h.repository.createGate = Completer<void>();
      h.notifier.passTo(playerB2);
      h.notifier.turnover();
      await h.notifier.undoLastEvent();
      expect(h.notifier.isBusy, isTrue);
      expect(h.notifier.canUndo, isFalse);
      expect((h.state as GameStatePlaying).currentThrower.participantId, 'b2');
      expect(h.repository.undoCalls, 0);
      h.repository.createGate!.complete();
      await h.settle();
      expect(h.notifier.canUndo, isTrue);
    },
  );

  test(
    'double undo and gameplay while undo is pending make one mutation',
    () async {
      await h.play();
      h.repository.undoGate = Completer<void>();
      final undo = h.notifier.undoLastEvent();
      await h.settle();
      await h.notifier.undoLastEvent();
      h.notifier.turnover();
      expect(h.state, isA<GameStatePlaying>());
      expect(h.repository.undoCalls, 1);
      h.repository.undoGate!.complete();
      await undo;
      expect(h.state, isA<GameStateTakerSelection>());
    },
  );

  for (final status in [404, 409]) {
    test(
      '$status preserves the UI and history when journal is unchanged',
      () async {
        await h.play();
        h.repository.undoError = failure(status);
        await h.notifier.undoLastEvent();
        expect(h.state, isA<GameStatePlaying>());
        expect(h.notifier.canUndo, isTrue);
        expect(h.notifier.message, isNotEmpty);
        expect(h.repository.undoCalls, 1);
      },
    );
  }

  test(
    'lost undo response reconciles the journal without retrying POST',
    () async {
      await h.play();
      h.repository.loseUndoResponse = true;
      await h.notifier.undoLastEvent();
      expect(h.state, isA<GameStateTakerSelection>());
      expect(h.repository.undoCalls, 1);
      expect(h.notifier.needsSync, isFalse);
    },
  );

  test(
    'failed reconciliation blocks mutations and retry only reads journal',
    () async {
      await h.play();
      h.repository.loseUndoResponse = true;
      h.repository.failReadsAfterUndo = true;
      await h.notifier.undoLastEvent();
      expect(h.notifier.needsSync, isTrue);
      expect(h.notifier.canUndo, isFalse);
      h.notifier.turnover();
      h.repository.failReadsAfterUndo = false;
      await h.notifier.synchronize();
      expect(h.state, isA<GameStateTakerSelection>());
      expect(h.notifier.needsSync, isFalse);
      expect(h.repository.undoCalls, 1);
    },
  );

  test(
    'changed server tail blocks undo before any destructive request',
    () async {
      await h.play();
      h.repository.events.add(
        Event1(
          id: 'other-client',
          sequenceNumber: 100,
          type: EventType.PICKUP,
          participantId: 'a1',
        ),
      );
      await h.notifier.undoLastEvent();
      expect(h.repository.undoCalls, 0);
      expect(h.notifier.needsSync, isTrue);
    },
  );

  test(
    'failed event create rolls back and never becomes an undo candidate',
    () async {
      await h.play();
      h.repository.createError = failure(409);
      h.notifier.scoreGoal(playerB2);
      await h.settle();
      expect(h.state, isA<GameStatePlaying>());
      expect(h.state.match.teams[1].score, 0);
      h.repository.createError = null;
      await h.notifier.undoLastEvent();
      expect(h.state, isA<GameStateTakerSelection>());
    },
  );

  test(
    'undo timeout end restores resumable break without resetting elapsed time',
    () async {
      await h.play();
      final timer = h.container.read(matchTimerProvider(testMatch.id).notifier);
      timer.pause();
      timer.start(initialDuration: const Duration(minutes: 8));
      h.notifier.startTimeout(testMatch.teams[1]);
      await h.settle();
      expect(h.state, isA<GameStateBreak>());
      expect(h.timer.isRunning, isFalse);
      h.notifier.endTimeout(testMatch.teams[1]);
      await h.settle();
      expect(h.timer.isRunning, isTrue);
      await h.notifier.undoLastEvent();
      expect((h.state as GameStateBreak).team?.id, 'team-b');
      expect(h.timer.isRunning, isFalse);
      expect(h.timer.elapsed, const Duration(minutes: 8));
      await h.notifier.undoLastEvent();
      expect(h.state, isA<GameStatePlaying>());
      expect(h.timer.isRunning, isTrue);
    },
  );

  test('undo halftime end and start restores lineup selection', () async {
    h.notifier.startHalftime();
    await h.settle();
    h.notifier.endHalftime();
    await h.settle();
    await h.notifier.undoLastEvent();
    expect((h.state as GameStateBreak).team, isNull);
    await h.notifier.undoLastEvent();
    expect(h.state, isA<GameStateLineupSelection>());
    expect(h.timer.isRunning, isTrue);
  });
}

DioException failure(int status) {
  final request = RequestOptions(path: '/events/undo');
  return DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: request, statusCode: status),
  );
}

const playerA1 = MatchParticipant(
  participantId: 'a1',
  kind: ParticipantKind.player,
  firstName: 'A',
  lastName: 'One',
  displayName: 'A One',
  number: 1,
  photoUrl: null,
);
const playerA2 = MatchParticipant(
  participantId: 'a2',
  kind: ParticipantKind.player,
  firstName: 'A',
  lastName: 'Two',
  displayName: 'A Two',
  number: 2,
  photoUrl: null,
);
const playerB1 = MatchParticipant(
  participantId: 'b1',
  kind: ParticipantKind.player,
  firstName: 'B',
  lastName: 'One',
  displayName: 'B One',
  number: 1,
  photoUrl: null,
);
const playerB2 = MatchParticipant(
  participantId: 'b2',
  kind: ParticipantKind.player,
  firstName: 'B',
  lastName: 'Two',
  displayName: 'B Two',
  number: 2,
  photoUrl: null,
);
const testMatch = MatchDetail(
  id: 'match-1',
  teams: [
    MatchTeam(
      id: 'team-a',
      name: 'Team A',
      score: 0,
      participants: [playerA1, playerA2],
    ),
    MatchTeam(
      id: 'team-b',
      name: 'Team B',
      score: 0,
      participants: [playerB1, playerB2],
    ),
  ],
  eventCount: 0,
  playersPerTeam: 2,
  status: MatchStatus.inProgress,
);

class GameHarness {
  GameHarness() {
    container = ProviderContainer(
      overrides: [matchEventsRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen(matchGameProvider(testMatch), (_, _) {});
    container.listen(matchTimerProvider(testMatch.id), (_, _) {});
    notifier = container.read(matchGameProvider(testMatch).notifier);
  }
  final repository = FakeEventsRepository();
  late final ProviderContainer container;
  late final MatchGameNotifier notifier;
  MatchGameState get state => container.read(matchGameProvider(testMatch));
  MatchTimerState get timer => container.read(matchTimerProvider(testMatch.id));
  Future<void> settle() => Future<void>.delayed(Duration.zero);
  Future<void> play() async {
    notifier.togglePlayer('a1', 0);
    notifier.togglePlayer('a2', 0);
    notifier.togglePlayer('b1', 1);
    notifier.togglePlayer('b2', 1);
    notifier.confirmLineupAndStartPull('team-a');
    notifier.selectPuller(playerA1);
    await settle();
    notifier.selectTaker(playerB1);
    await settle();
  }
}

class FakeEventsRepository implements MatchEventsRepository {
  final events = <Event>[];
  int sequence = 0;
  int undoCalls = 0;
  Completer<void>? createGate;
  Completer<void>? undoGate;
  Object? undoError;
  Object? createError;
  bool loseUndoResponse = false;
  bool failReadsAfterUndo = false;

  @override
  Future<Event> addEvent(CreateEventParams params) async {
    await createGate?.future;
    if (createError != null) throw createError!;
    final event = EventModel.fromJson({
      ...EventModel.fromEntity(params.event).toJson(),
      'id': 'event-${++sequence}',
      'sequenceNumber': sequence,
    }).toEntity();
    events.add(event);
    return event;
  }

  @override
  Future<List<Event>> getEvents(String matchId) async {
    if (failReadsAfterUndo && undoCalls > 0) throw failure(500);
    return List.of(events);
  }

  @override
  Future<Event> undoLastEvent(String matchId) async {
    undoCalls++;
    await undoGate?.future;
    if (undoError != null) throw undoError!;
    final event = events.removeLast();
    if (loseUndoResponse) {
      throw DioException(
        requestOptions: RequestOptions(path: '/events/undo'),
        type: DioExceptionType.receiveTimeout,
      );
    }
    return event;
  }

  @override
  Future<void> updateEvent(UpdateEventParams params) async =>
      throw UnimplementedError();
  @override
  Future<void> deleteEvent(String matchId, String eventId) async =>
      throw UnimplementedError();
}
