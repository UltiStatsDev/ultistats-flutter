import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/themes/app_themes.dart';
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
import 'package:ultistats/features/matches/presentation/widgets/match/common/pause_widget.dart';

void main() {
  _testMatch(
    'таймаут останавливает игру и возвращает прежнего владельца диска',
    (tester, fixture) async {
      fixture.startPlaying();
      final game = fixture.game;
      final before = fixture.state as GameStatePlaying;
      game.startTimeout(before.activeTeam);

      expect(fixture.state, isNot(isA<GameStatePlaying>()));
      expect(fixture.timer.isRunning, isFalse);
      final paused = fixture.state;
      final elapsed = fixture.timer.elapsed;
      game.startTimeout(before.activeTeam);
      game.startHalftime();
      game.endHalftime();
      game.endTimeout(before.opponentTeam);
      game.passTo(before.activeTeamLineup.last);
      game.turnover();
      game.scoreGoal(before.currentThrower);
      expect(fixture.state, same(paused));
      await tester.pump(const Duration(seconds: 5));
      expect(fixture.timer.elapsed, elapsed);

      game.endTimeout(before.activeTeam);
      game.endTimeout(before.activeTeam);
      await tester.pump();
      expect(fixture.state, same(before));
      expect(fixture.timer.isRunning, isTrue);
      await tester.pump(const Duration(seconds: 1));
      expect(fixture.timer.elapsed, elapsed + const Duration(seconds: 1));
      expect(fixture.pauseEvents, [
        EventType.TIMEOUT_START,
        EventType.TIMEOUT_END,
      ]);
      final timeoutEvents = fixture.repository.events.whereType<TeamEvent>();
      expect(timeoutEvents.map((event) => event.teamId), ['team2', 'team2']);
    },
  );

  _testMatch('халфтайм сохраняет выбранный состав и возобновляет таймер', (
    tester,
    fixture,
  ) async {
    fixture.game.togglePlayer('a1', 0);
    fixture.game.togglePlayer('b2', 1);
    final before = fixture.state;
    fixture.game.startHalftime();
    expect(fixture.state, isNot(isA<GameStateLineupSelection>()));
    expect(fixture.timer.isRunning, isFalse);
    final paused = fixture.state;
    final elapsed = fixture.timer.elapsed;
    fixture.game.startHalftime();
    fixture.game.startTimeout(fixture.match.teams[0]);
    fixture.game.endTimeout(fixture.match.teams[0]);
    fixture.game.togglePlayer('a2', 0);
    fixture.game.confirmLineupAndStartPull('team1');
    fixture.game.finishMatch();
    expect(fixture.state, same(paused));
    await tester.pump(const Duration(seconds: 5));
    expect(fixture.timer.elapsed, elapsed);

    fixture.game.endHalftime();
    fixture.game.endHalftime();
    await tester.pump();
    expect(fixture.state, same(before));
    expect(fixture.timer.isRunning, isTrue);
    expect(fixture.pauseEvents, [
      EventType.HALFTIME_START,
      EventType.HALFTIME_END,
    ]);
  });

  _testMatch('недоступные команды паузы не создают событий', (
    tester,
    fixture,
  ) async {
    final before = fixture.state;
    fixture.game.startTimeout(fixture.match.teams[0]);
    fixture.game.endTimeout(fixture.match.teams[0]);
    fixture.game.endHalftime();
    await tester.pump();
    expect(fixture.state, same(before));
    expect(fixture.pauseEvents, isEmpty);
    expect(fixture.timer.isRunning, isTrue);

    fixture.startPlaying();
    final playing = fixture.state;
    fixture.game.startTimeout(fixture.match.teams[0]);
    fixture.game.startHalftime();
    await tester.pump();
    expect(fixture.state, same(playing));
    expect(fixture.pauseEvents, isEmpty);
  });

  _testMatch('таймаут отображается в теле матча без диалога', (
    tester,
    fixture,
  ) async {
    fixture.startPlaying();
    final before = fixture.state;
    await fixture.showScreen(tester);
    await tester.tap(find.text('T'));
    await tester.pump();

    expect(find.byType(Dialog), findsNothing);
    expect(find.text('ТАЙМАУТ'), findsOneWidget);
    expect(find.text('Команда 2'), findsNWidgets(2));
    expect(find.text('0:0'), findsOneWidget);
    expect(find.text('ВРЕМЯ МАТЧА'), findsOneWidget);
    expect(find.text('DROP'), findsNothing);
    expect(fixture.timer.isRunning, isFalse);
    expect(
      tester
          .widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'T'))
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'HT'))
          .onPressed,
      isNull,
    );
    expect(
      tester.widget<PopScope>(find.byType(PopScope).first).canPop,
      isFalse,
    );
    await tester.tap(find.text('ЗАВЕРШИТЬ ТАЙМАУТ'));
    await tester.pump();
    expect(fixture.state, same(before));
    expect(find.text('ТАЙМАУТ'), findsNothing);
    expect(find.text('DROP'), findsOneWidget);
    expect(fixture.timer.isRunning, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  _testMatch('халфтайм отображается в теле матча без диалога', (
    tester,
    fixture,
  ) async {
    final before = fixture.state;
    await fixture.showScreen(tester);
    await tester.tap(find.text('HT'));
    await tester.pump();

    expect(find.byType(Dialog), findsNothing);
    expect(find.text('ПЕРЕРЫВ'), findsOneWidget);
    expect(find.text('Между половинами'), findsOneWidget);
    expect(find.text('0:0'), findsOneWidget);
    expect(find.text('Окончить матч'), findsNothing);
    expect(fixture.timer.isRunning, isFalse);
    expect(
      tester.widget<PopScope>(find.byType(PopScope).first).canPop,
      isFalse,
    );
    await tester.tap(find.text('ЗАВЕРШИТЬ ПЕРЕРЫВ'));
    await tester.pump();
    expect(fixture.state, same(before));
    expect(find.text('Окончить матч'), findsOneWidget);
    expect(fixture.timer.isRunning, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  _testMatch('выход назад заблокирован во время обеих пауз', (
    tester,
    fixture,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: fixture.container,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: createLightTheme(),
          home: const Scaffold(body: Text('Список матчей')),
        ),
      ),
    );
    navigatorKey.currentState!.push<void>(
      MaterialPageRoute(builder: (_) => MatchScreen(match: fixture.match)),
    );
    await tester.pumpAndSettle();

    fixture.game.startHalftime();
    await tester.pump();
    await navigatorKey.currentState!.maybePop();
    await tester.pumpAndSettle();
    expect(find.text('ПЕРЕРЫВ'), findsOneWidget);
    expect(fixture.timer.isRunning, isFalse);
    expect(fixture.pauseEvents, [EventType.HALFTIME_START]);

    fixture.game.endHalftime();
    fixture.startPlaying();
    fixture.game.startTimeout(fixture.match.teams[1]);
    await tester.pump();
    await navigatorKey.currentState!.maybePop();
    await tester.pumpAndSettle();
    expect(find.text('ТАЙМАУТ'), findsOneWidget);
    expect(fixture.timer.isRunning, isFalse);
    expect(fixture.pauseEvents, [
      EventType.HALFTIME_START,
      EventType.HALFTIME_END,
      EventType.TIMEOUT_START,
    ]);

    fixture.game.endTimeout(fixture.match.teams[1]);
    await tester.pump();
    await navigatorKey.currentState!.maybePop();
    await tester.pumpAndSettle();
    expect(find.byType(MatchScreen), findsNothing);
    expect(find.text('Список матчей'), findsOneWidget);
  });

  for (final timeout in [true, false]) {
    _testMatch(
      '${timeout ? 'таймаут' : 'халфтайм'} доступен на маленьком экране',
      (tester, fixture) async {
        tester.view.physicalSize = const Size(320, 480);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        if (timeout) {
          fixture.startPlaying();
          fixture.game.startTimeout(fixture.match.teams[1]);
        } else {
          fixture.game.startHalftime();
        }
        await fixture.showScreen(tester);
        final finish = find.text(
          timeout ? 'ЗАВЕРШИТЬ ТАЙМАУТ' : 'ЗАВЕРШИТЬ ПЕРЕРЫВ',
        );
        await tester.ensureVisible(finish);
        await tester.tap(finish);
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(fixture.timer.isRunning, isTrue);
      },
    );
  }

  testWidgets(
    'счётчик паузы использует её начало и не сбрасывается при перестроении',
    (tester) async {
      final startedAt = DateTime.now().subtract(const Duration(seconds: 65));
      Widget screen(Key key) => MaterialApp(
        home: Scaffold(
          body: PauseWidget(
            key: key,
            startedAt: startedAt,
            title: 'ТАЙМАУТ',
            subtitle: 'Команда 1',
            finishLabel: 'ЗАВЕРШИТЬ ТАЙМАУТ',
            onFinish: () {},
          ),
        ),
      );
      int elapsedSeconds() {
        final text = tester.widget<Text>(
          find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                RegExp(r'^\d{2}:\d{2}$').hasMatch(widget.data ?? ''),
          ),
        );
        final parts = text.data!.split(':').map(int.parse).toList();
        return parts[0] * 60 + parts[1];
      }

      await tester.pumpWidget(screen(const ValueKey('first')));
      expect(elapsedSeconds(), inInclusiveRange(65, 70));
      await tester.pumpWidget(screen(const ValueKey('rebuilt')));
      expect(elapsedSeconds(), inInclusiveRange(65, 70));
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('панель паузы прокручивается при крупном шрифте и малой высоте', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 240);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var finished = false;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.5)),
          child: child!,
        ),
        home: Scaffold(
          body: PauseWidget(
            startedAt: DateTime.now(),
            title: 'ТАЙМАУТ',
            subtitle: 'Команда с длинным названием',
            finishLabel: 'ЗАВЕРШИТЬ ТАЙМАУТ',
            onFinish: () => finished = true,
          ),
        ),
      ),
    );
    await tester.ensureVisible(find.text('ЗАВЕРШИТЬ ТАЙМАУТ'));
    await tester.tap(find.text('ЗАВЕРШИТЬ ТАЙМАУТ'));
    expect(finished, isTrue);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

void _testMatch(
  String description,
  Future<void> Function(WidgetTester tester, _Fixture fixture) body,
) {
  testWidgets(description, (tester) async {
    final fixture = await _Fixture.create(tester);
    try {
      await body(tester, fixture);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      fixture.container.dispose();
    }
  });
}

class _Fixture {
  _Fixture(this.container, this.repository);

  final ProviderContainer container;
  final _RecordingEventsRepository repository;
  final match = MatchDetail(
    id: 'match',
    teams: [
      MatchTeam(
        id: 'team1',
        name: 'Команда 1',
        score: 0,
        participants: _players('a'),
      ),
      MatchTeam(
        id: 'team2',
        name: 'Команда 2',
        score: 0,
        participants: _players('b'),
      ),
    ],
    eventCount: 0,
    playersPerTeam: 2,
    status: MatchStatus.inProgress,
  );

  MatchGameNotifier get game =>
      container.read(matchGameProvider(match).notifier);
  MatchGameState get state => container.read(matchGameProvider(match));
  MatchTimerState get timer => container.read(matchTimerProvider(match.id));
  List<EventType> get pauseEvents => repository.events
      .map((event) => event.type)
      .where(
        (type) => const [
          EventType.TIMEOUT_START,
          EventType.TIMEOUT_END,
          EventType.HALFTIME_START,
          EventType.HALFTIME_END,
        ].contains(type),
      )
      .toList();

  static Future<_Fixture> create(WidgetTester tester) async {
    final repository = _RecordingEventsRepository();
    final container = ProviderContainer(
      overrides: [matchEventsRepositoryProvider.overrideWithValue(repository)],
    );
    final fixture = _Fixture(container, repository);
    container.listen(matchTimerProvider(fixture.match.id), (_, _) {});
    container.listen(matchGameProvider(fixture.match), (_, _) {});
    await tester.pump();
    return fixture;
  }

  void startPlaying() {
    for (final id in ['a1', 'a2']) {
      game.togglePlayer(id, 0);
    }
    for (final id in ['b1', 'b2']) {
      game.togglePlayer(id, 1);
    }
    game.confirmLineupAndStartPull('team1');
    game.selectPuller(match.teams[0].participants.first);
    game.selectTaker(match.teams[1].participants.first);
    game.passTo(match.teams[1].participants[1]);
  }

  Future<void> showScreen(WidgetTester tester) => tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: createLightTheme(),
        home: MatchScreen(match: match),
      ),
    ),
  );
}

List<MatchParticipant> _players(String prefix) => List.generate(4, (index) {
  return MatchParticipant(
    participantId: '$prefix${index + 1}',
    kind: index < 2 ? ParticipantKind.player : ParticipantKind.unknown,
    firstName: null,
    lastName: null,
    displayName: '$prefix${index + 1}',
    number: index < 2 ? index + 1 : null,
    photoUrl: null,
  );
});

class _RecordingEventsRepository implements MatchEventsRepository {
  final events = <Event>[];

  @override
  Future<void> addEvent(CreateEventParams params) async =>
      events.add(params.event);

  @override
  Future<List<Event>> getEvents(String matchId) async => List.of(events);

  @override
  Future<void> updateEvent(UpdateEventParams params) =>
      throw UnimplementedError();

  @override
  Future<void> deleteEvent(String matchId, String eventId) =>
      throw UnimplementedError();
}
