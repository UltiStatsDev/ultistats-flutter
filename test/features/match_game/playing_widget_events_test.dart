import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/match_game/domain/match_action.dart';
import 'package:ultistats/features/match_game/domain/match_game_state.dart';
import 'package:ultistats/features/match_game/presentation/providers/match_game_notifier.dart';
import 'package:ultistats/features/match_game/presentation/providers/match_timer_notifier.dart';
import 'package:ultistats/features/match_game/presentation/screens/match_game_screen.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/domain/params/update_event_params.dart';
import 'package:ultistats/features/matches/domain/repositories/match_events_repository.dart';

void main() {
  testWidgets('кнопки действий стоят в рядках подходящих игроков', (
    tester,
  ) async {
    final fixture = await _Fixture.create(tester);
    try {
      fixture.startPlaying();
      await fixture.showScreen(tester);
      await tester.pump();

      final thrower = (fixture.state as GameStatePlaying).currentThrower;
      final throwerRow = _rowOf(tester, thrower.displayName);

      for (final label in ['THROW', 'BLOCK', 'INTERCEPT', 'CALLAHAN']) {
        expect(
          find.descendant(of: throwerRow, matching: find.text(label)),
          findsOneWidget,
          reason: 'у бросающего должна быть кнопка $label',
        );
      }
      expect(
        find.descendant(of: throwerRow, matching: find.text('PASS')),
        findsNothing,
      );

      final receiverRow = _rowOf(tester, 'b1');
      for (final label in ['PASS', 'GOAL']) {
        expect(
          find.descendant(of: receiverRow, matching: find.text(label)),
          findsOneWidget,
        );
      }
      expect(
        find.descendant(of: receiverRow, matching: find.text('THROW')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      fixture.container.dispose();
    }
  });

  testWidgets('перехват выбирается в диалоге и передаёт владение', (
    tester,
  ) async {
    final fixture = await _Fixture.create(tester);
    try {
      fixture.startPlaying();
      await fixture.showScreen(tester);
      await tester.pump();

      final before = fixture.state as GameStatePlaying;
      await tester.tap(find.text('INTERCEPT'));
      await tester.pump();

      expect(find.text('Кто перехватил пас?'), findsOneWidget);
      // В диалоге только игроки противоположной команды.
      expect(find.text('a1 #1'), findsOneWidget);
      expect(find.text('a2 #2'), findsOneWidget);
      expect(find.text('b1 #1'), findsNothing);

      await tester.tap(find.text('a1 #1'));
      await tester.pump();
      await tester.pump();

      final after = fixture.state as GameStatePlaying;
      expect(after.activeTeam.id, before.opponentTeam.id);
      expect(after.currentThrower.participantId, 'a1');

      final interception = fixture.events.singleWhere(
        (event) => event.type == EventType.INTERCEPTION,
      );
      expect(interception, isA<Event2>());
      final event = interception as Event2;
      expect(event.participantId, before.currentThrower.participantId);
      expect(event.toParticipantId, 'a1');
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      fixture.container.dispose();
    }
  });

  testWidgets('блок выбирается в диалоге вместе с видом', (tester) async {
    final fixture = await _Fixture.create(tester);
    try {
      fixture.startPlaying();
      await fixture.showScreen(tester);
      await tester.pump();

      await tester.tap(find.text('BLOCK'));
      await tester.pump();

      expect(find.text('Кто заблокировал бросок?'), findsOneWidget);

      await tester.tap(find.text('Маркер'));
      await tester.pump();
      await tester.tap(find.text('a2 #2'));
      await tester.pump();
      await tester.pump();

      expect(
        fixture.events.map((event) => event.type),
        contains(EventType.BLOCK_MARKER),
      );
      expect(fixture.state, isA<GameStateTakerSelection>());
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      fixture.container.dispose();
    }
  });

  testWidgets('brick доступен на экране подбора после пулла', (tester) async {
    final fixture = await _Fixture.create(tester);
    try {
      for (final id in ['a1', 'a2']) {
        fixture.game.dispatch(
          TogglePlayerAction(participantId: id, teamIndex: 0),
        );
      }
      for (final id in ['b1', 'b2']) {
        fixture.game.dispatch(
          TogglePlayerAction(participantId: id, teamIndex: 1),
        );
      }
      fixture.game.dispatch(ConfirmLineupAction(pullingTeamId: 'team1'));
      fixture.game.dispatch(
        SelectPullerAction(fixture.match.teams[0].participants.first),
      );
      await fixture.showScreen(tester);
      await tester.pump();

      expect(find.text('Брик от a1'), findsOneWidget);
      await tester.tap(find.text('BRICK'));
      await tester.pump();
      await tester.pump();

      expect(
        fixture.events.map((event) => event.type),
        contains(EventType.BRICK),
      );
      expect(find.text('Брик от a1'), findsNothing);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      fixture.container.dispose();
    }
  });
}

/// Рядок игрока, внутри которого стоят его кнопки действий.
Finder _rowOf(WidgetTester tester, String displayName) =>
    find.ancestor(of: find.text(displayName), matching: find.byType(Row)).first;

class _Fixture {
  _Fixture(this.container, this.repository);

  final ProviderContainer container;
  final _RecordingEventsRepository repository;
  final match = _match();

  MatchGameNotifier get game =>
      container.read(matchGameProvider(match).notifier);
  MatchGameState get state => container.read(matchGameProvider(match));
  List<Event> get events => repository.events;

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
      game.dispatch(TogglePlayerAction(participantId: id, teamIndex: 0));
    }
    for (final id in ['b1', 'b2']) {
      game.dispatch(TogglePlayerAction(participantId: id, teamIndex: 1));
    }
    game.dispatch(ConfirmLineupAction(pullingTeamId: 'team1'));
    game.dispatch(SelectPullerAction(match.teams[0].participants.first));
    game.dispatch(SelectTakerAction(match.teams[1].participants.first));
    game.dispatch(PassToAction(match.teams[1].participants[1]));
  }

  Future<void> showScreen(WidgetTester tester) => tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: createLightTheme(),
        home: MatchGameScreen(match: match),
      ),
    ),
  );
}

MatchDetail _match() => MatchDetail(
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
  Future<Event> undoLastEvent(String matchId) async => events.removeLast();

  @override
  Future<void> updateEvent(UpdateEventParams params) =>
      throw UnimplementedError();

  @override
  Future<void> deleteEvent(String matchId, String eventId) =>
      throw UnimplementedError();
}
