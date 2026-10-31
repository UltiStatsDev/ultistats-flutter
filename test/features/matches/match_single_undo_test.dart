import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/themes/app_themes.dart';
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
import 'package:ultistats/features/matches/presentation/screens/match_screen.dart';

void main() {
  undoTest('локальный выбор команды отменяется один раз без POST undo', (
    tester,
    f,
  ) async {
    expect(f.undoButton.onPressed, isNull);
    f.selectLineup();
    final before = f.state;
    f.game.confirmLineupAndStartPull('a');
    await tester.pump();
    expect(f.undoButton.onPressed, isNotNull);
    await f.undo(tester);
    expect(f.state, same(before));
    expect(f.repo.undoCalls, 0);
    expect(f.undoButton.onPressed, isNull);
    f.game.confirmLineupAndStartPull('b');
    await tester.pump();
    expect(f.undoButton.onPressed, isNotNull);
    await f.undo(tester);
    expect(f.repo.undoCalls, 0);
  });

  undoTest('пулл возвращает выбор пуллера и не открывает предыдущую отмену', (
    tester,
    f,
  ) async {
    f.selectLineup();
    f.game.confirmLineupAndStartPull('a');
    final before = f.state;
    await f.step(tester, () => f.game.selectPuller(f.a1));
    expect(f.state, isA<GameStateTakerSelection>());
    await f.undo(tester);
    expect(f.state, same(before));
    expect(f.state, isA<GameStatePullerSelection>());
    expect(f.repo.undoCalls, 1);
    expect(f.repo.events, isEmpty);
    expect(f.undoButton.onPressed, isNull);
    await tester.tap(find.text('Отменить действие'));
    await tester.pump();
    expect(f.repo.undoCalls, 1);
    expect(f.state, same(before));
  });

  undoTest('пас отменяется один раз и новое действие перезаписывает буфер', (
    tester,
    f,
  ) async {
    await f.playing(tester);
    final before = f.state;
    await f.step(tester, () => f.game.passTo(f.b2));
    expect((f.state as GameStatePlaying).currentThrower, f.b2);
    await f.undo(tester);
    expect(f.state, same(before));
    expect(f.undoButton.onPressed, isNull);
    await f.step(tester, () => f.game.passTo(f.b2));
    expect(f.undoButton.onPressed, isNotNull);
    await f.undo(tester);
    expect(f.repo.undoCalls, 2);
    expect(f.repo.events.map((e) => e.type), [
      EventType.PULL,
      EventType.PICKUP,
    ]);
  });

  undoTest('отмена гола возвращает счёт состав и владельца диска', (
    tester,
    f,
  ) async {
    await f.playing(tester);
    final before = f.state;
    await f.step(tester, () => f.game.scoreGoal(f.b2));
    expect(f.state.match.teams[1].score, 1);
    expect(f.state, isA<GameStateLineupSelection>());
    await f.undo(tester);
    expect(f.state, same(before));
    expect(f.state.match.teams[1].score, 0);
    expect((f.state as GameStatePlaying).currentThrower, f.b1);
  });

  undoTest('два новых действия оставляют только последнее состояние в буфере', (
    tester,
    f,
  ) async {
    await f.playing(tester);
    await f.step(tester, () => f.game.passTo(f.b2));
    final beforeLast = f.state;
    await f.step(tester, () => f.game.passTo(f.b1));
    await f.undo(tester);
    expect(f.state, same(beforeLast));
    expect((f.state as GameStatePlaying).currentThrower, f.b2);
    expect(f.repo.events.map((e) => e.type), [
      EventType.PULL,
      EventType.PICKUP,
      EventType.PASS,
    ]);
    expect(f.undoButton.onPressed, isNull);
    expect(f.repo.undoCalls, 1);
  });

  undoTest('подбор и потеря диска восстанавливают предыдущую фазу', (
    tester,
    f,
  ) async {
    f.selectLineup();
    f.game.confirmLineupAndStartPull('a');
    await f.step(tester, () => f.game.selectPuller(f.a1));
    final taker = f.state;
    await f.step(tester, () => f.game.selectTaker(f.b1));
    await f.undo(tester);
    expect(f.state, same(taker));
    await f.step(tester, () => f.game.selectTaker(f.b1));
    final playing = f.state;
    await f.step(tester, f.game.turnover);
    expect((f.state as GameStateTakerSelection).activeTeam.id, 'a');
    await f.undo(tester);
    expect(f.state, same(playing));
  });

  for (final timeout in [true, false]) {
    undoTest(
      'отмена начала и конца ${timeout ? 'таймаута' : 'халфтайма'} не трогает время',
      (tester, f) async {
        if (timeout) await f.playing(tester);
        final before = f.state;
        void start() => timeout
            ? f.game.startTimeout(f.match.teams[1])
            : f.game.startHalftime();
        void end() => timeout
            ? f.game.endTimeout(f.match.teams[1])
            : f.game.endHalftime();
        final elapsed = f.timer.elapsed;
        await f.step(tester, start);
        expect(f.timer.isRunning, isTrue);
        await tester.pump(const Duration(seconds: 3));
        await f.undo(tester);
        expect(f.state, same(before));
        expect(f.timer.elapsed, elapsed + const Duration(seconds: 3));
        await f.step(tester, start);
        final pause = f.state;
        await f.step(tester, end);
        await tester.pump(const Duration(seconds: 2));
        await f.undo(tester);
        expect(f.state, same(pause));
        expect(f.timer.isRunning, isTrue);
        expect(f.timer.elapsed, elapsed + const Duration(seconds: 5));
        expect(f.undoButton.onPressed, isNull);
      },
    );
  }

  undoTest('повторный тап и игровые действия заблокированы до ответа undo', (
    tester,
    f,
  ) async {
    await f.playing(tester);
    final before = f.state;
    await f.step(tester, () => f.game.passTo(f.b2));
    f.repo.undoGate = Completer<void>();
    await tester.tap(find.text('Отменить действие'));
    await tester.pump();
    expect(f.repo.undoCalls, 1);
    expect(f.undoButton.onPressed, isNull);
    final count = f.repo.events.length;
    f.game.passTo(f.b1);
    f.game.startTimeout(f.match.teams[1]);
    await tester.tap(find.text('Отменить действие'));
    await tester.pump();
    expect(f.repo.events.length, count);
    expect(f.repo.undoCalls, 1);
    expect(
      tester.widget<PopScope>(find.byType(PopScope).first).canPop,
      isFalse,
    );
    f.repo.undoGate!.complete();
    await tester.pump();
    expect(f.state, same(before));
    expect(f.undoButton.onPressed, isNull);
  });

  undoTest('потерянный ответ undo подтверждается чтением без повторного POST', (
    tester,
    f,
  ) async {
    await f.playing(tester);
    final before = f.state;
    await f.step(tester, () => f.game.passTo(f.b2));
    f.repo.loseUndoResponse = true;
    await f.undo(tester);
    expect(f.repo.undoCalls, 1);
    expect(f.state, same(before));
    expect(f.undoButton.onPressed, isNull);
    expect(f.repo.events.last.type, EventType.PICKUP);
  });

  undoTest('чужое изменение журнала не отменяется', (tester, f) async {
    await f.playing(tester);
    await f.step(tester, () => f.game.passTo(f.b2));
    final before = f.state;
    await f.repo.addEvent(
      CreateEventParams(
        matchId: 'match',
        event: Event2.pass(participantId: 'b2', toParticipantId: 'b1'),
      ),
    );
    await f.undo(tester);
    expect(f.repo.undoCalls, 0);
    expect(f.state, same(before));
    expect(f.undoButton.onPressed, isNull);
    expect(find.textContaining('Журнал матча изменился'), findsOneWidget);
  });

  undoTest('отклонённое событие не оставляет оптимистическое состояние', (
    tester,
    f,
  ) async {
    await f.playing(tester);
    final before = f.state;
    f.repo.rejectCreate = true;
    await f.step(tester, () => f.game.passTo(f.b2));
    expect(f.state, same(before));
    expect(find.textContaining('Событие отклонено'), findsOneWidget);
    expect(f.repo.events.last.type, EventType.PICKUP);
  });

  undoTest('новое событие блокирует запись и undo до подтверждения', (
    tester,
    f,
  ) async {
    await f.playing(tester);
    f.repo.createGate = Completer<void>();
    f.game.passTo(f.b2);
    await tester.pump();
    final calls = f.repo.createCalls;
    f.game.passTo(f.b1);
    f.game.turnover();
    await tester.tap(find.text('Отменить действие'));
    await tester.pump();
    expect(f.repo.createCalls, calls);
    expect(f.repo.undoCalls, 0);
    expect(f.undoButton.onPressed, isNull);
    f.repo.createGate!.complete();
    await tester.pump();
    expect(f.undoButton.onPressed, isNotNull);
  });

  for (final status in [404, 409]) {
    undoTest('отклонённый undo $status не откатывает UI и не повторяется', (
      tester,
      f,
    ) async {
      await f.playing(tester);
      await f.step(tester, () => f.game.passTo(f.b2));
      final before = f.state;
      f.repo.undoFailure = status;
      await f.undo(tester);
      expect(f.state, same(before));
      expect(f.repo.undoCalls, 1);
      expect(f.undoButton.onPressed, isNull);
      expect(f.game.canInteract, isTrue);
      f.repo.undoFailure = null;
      await f.step(tester, () => f.game.passTo(f.b1));
      expect(f.undoButton.onPressed, isNotNull);
    });
  }

  undoTest('неопределённый результат разрешает только проверку GET', (
    tester,
    f,
  ) async {
    await f.playing(tester);
    final original = f.state;
    await f.step(tester, () => f.game.passTo(f.b2));
    f.repo.undoFailure = 500;
    await f.undo(tester);
    expect(f.repo.undoCalls, 1);
    expect(f.game.canInteract, isFalse);
    expect(f.undoButton.onPressed, isNull);
    expect(find.text('Проверить отмену'), findsOneWidget);
    await tester.tap(find.text('Проверить отмену'));
    await tester.pump();
    expect(f.repo.undoCalls, 1);
    expect(f.game.canInteract, isFalse);
    // Simulate a late commit whose HTTP response was lost.
    f.repo.events.removeLast();
    await tester.tap(find.text('Проверить отмену'));
    await tester.pump();
    expect(f.repo.undoCalls, 1);
    expect(f.state, same(original));
    expect(f.game.canInteract, isTrue);
    expect(f.undoButton.onPressed, isNull);
  });

  undoTest('неудачная проверка после потерянного ответа не повторяет POST', (
    tester,
    f,
  ) async {
    await f.playing(tester);
    final before = f.state;
    await f.step(tester, () => f.game.passTo(f.b2));
    f.repo.loseUndoResponse = true;
    f.repo.failReadAfterUndo = true;
    await f.undo(tester);
    expect(f.game.canInteract, isFalse);
    expect(f.repo.undoCalls, 1);
    f.repo.failReadAfterUndo = false;
    await tester.tap(find.text('Проверить отмену'));
    await tester.pump();
    expect(f.state, same(before));
    expect(f.repo.undoCalls, 1);
    expect(f.undoButton.onPressed, isNull);
  });

  undoTest('несовпавший ответ undo не применяется к снимку', (tester, f) async {
    await f.playing(tester);
    await f.step(tester, () => f.game.passTo(f.b2));
    final before = f.state;
    f.repo.wrongUndoResponse = true;
    await f.undo(tester);
    expect(f.state, same(before));
    expect(f.repo.undoCalls, 1);
    expect(f.game.canInteract, isFalse);
    expect(f.undoButton.onPressed, isNull);
  });

  undoTest('потерянный ответ записи не позволяет дублировать событие', (
    tester,
    f,
  ) async {
    await f.playing(tester);
    f.repo.loseCreateResponse = true;
    await f.step(tester, () => f.game.passTo(f.b2));
    final count = f.repo.createCalls;
    f.game.passTo(f.b1);
    await tester.pump();
    expect(f.repo.createCalls, count);
    expect(f.game.canInteract, isFalse);
    expect(f.undoButton.onPressed, isNull);
    expect(tester.widget<PopScope>(find.byType(PopScope).first).canPop, isTrue);
  });

  undoTest('кнопка вписывается в маленький экран и использует тему', (
    tester,
    f,
  ) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    f.game.startHalftime();
    await tester.pump();
    expect(find.text('Отменить действие'), findsOneWidget);
    expect(
      f.undoButton.style!.foregroundColor!.resolve({}),
      createLightTheme().colorScheme.onPrimary,
    );
    await tester.ensureVisible(find.text('Отменить действие'));
    await f.undo(tester);
    expect(f.state, isA<GameStateLineupSelection>());
    expect(tester.takeException(), isNull);
  });
}

void undoTest(
  String name,
  Future<void> Function(WidgetTester, UndoFixture) body,
) {
  testWidgets(name, (tester) async {
    final f = UndoFixture();
    try {
      f.container.listen(matchTimerProvider('match'), (_, _) {});
      f.container.listen(matchGameProvider(f.match), (_, _) {});
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: f.container,
          child: MaterialApp(
            theme: createLightTheme(),
            home: MatchScreen(match: f.match),
          ),
        ),
      );
      expect(find.text('Отменить действие'), findsOneWidget);
      await body(tester, f);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      f.container.dispose();
    }
  });
}

class UndoFixture {
  UndoFixture() {
    container = ProviderContainer(
      overrides: [matchEventsRepositoryProvider.overrideWithValue(repo)],
    );
  }
  final repo = RecordingUndoRepository();
  late final ProviderContainer container;
  final match = MatchDetail(
    id: 'match',
    teams: [
      MatchTeam(
        id: 'a',
        name: 'Команда А',
        score: 0,
        participants: participants('a'),
      ),
      MatchTeam(
        id: 'b',
        name: 'Команда Б',
        score: 0,
        participants: participants('b'),
      ),
    ],
    eventCount: 0,
    playersPerTeam: 2,
    status: MatchStatus.inProgress,
  );
  MatchGameNotifier get game =>
      container.read(matchGameProvider(match).notifier);
  MatchGameState get state => container.read(matchGameProvider(match));
  MatchTimerState get timer => container.read(matchTimerProvider('match'));
  MatchParticipant get a1 => match.teams[0].participants[0];
  MatchParticipant get b1 => match.teams[1].participants[0];
  MatchParticipant get b2 => match.teams[1].participants[1];
  TextButton get undoButton => testerButton();
  TextButton testerButton() =>
      (find
              .widgetWithText(TextButton, 'Отменить действие')
              .evaluate()
              .single
              .widget
          as TextButton);
  void selectLineup() {
    for (final id in ['a1', 'a2']) {
      game.togglePlayer(id, 0);
    }
    for (final id in ['b1', 'b2']) {
      game.togglePlayer(id, 1);
    }
  }

  Future<void> step(WidgetTester tester, void Function() action) async {
    action();
    await tester.pump();
  }

  Future<void> undo(WidgetTester tester) async {
    await tester.tap(find.text('Отменить действие'));
    await tester.pump();
  }

  Future<void> playing(WidgetTester tester) async {
    selectLineup();
    game.confirmLineupAndStartPull('a');
    await step(tester, () => game.selectPuller(a1));
    await step(tester, () => game.selectTaker(b1));
  }
}

List<MatchParticipant> participants(String prefix) => List.generate(
  4,
  (i) => MatchParticipant(
    participantId: '$prefix${i + 1}',
    kind: i < 2 ? ParticipantKind.player : ParticipantKind.unknown,
    firstName: null,
    lastName: null,
    displayName: '$prefix${i + 1}',
    number: i + 1,
    photoUrl: null,
  ),
);

class RecordingUndoRepository implements MatchEventsRepository {
  final events = <Event>[];
  int sequence = 0;
  int undoCalls = 0;
  bool loseUndoResponse = false;
  bool rejectCreate = false;
  int createCalls = 0;
  int? undoFailure;
  bool failReadAfterUndo = false;
  bool wrongUndoResponse = false;
  bool loseCreateResponse = false;
  Completer<void>? createGate;
  Completer<void>? undoGate;
  @override
  Future<List<Event>> getEvents(String matchId) async {
    if (failReadAfterUndo && undoCalls > 0) throw StateError('Offline');
    return List.of(events);
  }

  @override
  Future<Event> addEvent(CreateEventParams params) async {
    createCalls++;
    if (createGate != null) await createGate!.future;
    if (rejectCreate) {
      throw DioException(
        requestOptions: RequestOptions(),
        response: Response(requestOptions: RequestOptions(), statusCode: 409),
      );
    }
    final event = EventModel.fromJson({
      ...EventModel.fromEntity(params.event).toJson(),
      'id': 'event-${++sequence}',
      'sequenceNumber': sequence,
    }).toEntity();
    events.add(event);
    if (loseCreateResponse) {
      throw DioException.connectionTimeout(
        timeout: const Duration(seconds: 1),
        requestOptions: RequestOptions(),
      );
    }
    return event;
  }

  @override
  Future<Event> undoLastEvent(String matchId) async {
    undoCalls++;
    if (undoGate != null) await undoGate!.future;
    if (undoFailure != null) {
      throw DioException(
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: undoFailure,
        ),
      );
    }
    final removed = events.removeLast();
    if (wrongUndoResponse) return events.first;
    if (loseUndoResponse) {
      throw DioException.connectionTimeout(
        timeout: const Duration(seconds: 1),
        requestOptions: RequestOptions(),
      );
    }
    return removed;
  }

  @override
  Future<void> updateEvent(UpdateEventParams params) async =>
      throw UnimplementedError();
  @override
  Future<void> deleteEvent(String matchId, String eventId) async =>
      throw UnimplementedError();
}
