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
  testWidgets('кнопка отмены откатывает действие и гаснет', (tester) async {
    final repository = _RecordingEventsRepository();
    final container = _createContainer(repository);
    try {
      final match = _match();

      final game = container.read(matchGameProvider(match).notifier);
      _startPlaying(game, match);
      final beforePass = container.read<MatchGameState>(
        matchGameProvider(match),
      );

      game.dispatch(PassToAction(match.teams[1].participants.last));
      await _showScreen(tester, container, match);
      await tester.pump();

      expect(_undoButton(tester).onPressed, isNotNull);

      await tester.tap(find.byIcon(Icons.undo));
      await tester.pumpAndSettle();

      expect(
        container.read<MatchGameState>(matchGameProvider(match)),
        same(beforePass),
      );
      expect(repository.undoCalls, ['match']);
      expect(_undoButton(tester).onPressed, isNull);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
    }
  });

  testWidgets('без действий кнопка отмены недоступна', (tester) async {
    final container = _createContainer(_RecordingEventsRepository());
    try {
      await _showScreen(tester, container, _match());
      await tester.pump();

      expect(_undoButton(tester).onPressed, isNull);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
    }
  });

  testWidgets('счёт остаётся по центру экрана', (tester) async {
    final container = _createContainer(_RecordingEventsRepository());
    try {
      await _showScreen(tester, container, _match());
      await tester.pump();

      final screenWidth =
          tester.view.physicalSize.width / tester.view.devicePixelRatio;
      expect(
        tester.getCenter(find.text('0:0')).dx,
        closeTo(screenWidth / 2, 0.5),
      );
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
    }
  });
}

IconButton _undoButton(WidgetTester tester) =>
    tester.widget<IconButton>(find.widgetWithIcon(IconButton, Icons.undo));

Future<void> _showScreen(
  WidgetTester tester,
  ProviderContainer container,
  MatchDetail match,
) => tester.pumpWidget(
  UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: createLightTheme(),
      home: MatchGameScreen(match: match),
    ),
  ),
);

ProviderContainer _createContainer(MatchEventsRepository repository) {
  final container = ProviderContainer(
    overrides: [matchEventsRepositoryProvider.overrideWithValue(repository)],
  );
  final match = _match();
  container.listen(matchTimerProvider(match.id), (_, _) {});
  container.listen(matchGameProvider(match), (_, _) {});
  return container;
}

void _startPlaying(MatchGameNotifier game, MatchDetail match) {
  for (final id in ['a1', 'a2']) {
    game.dispatch(TogglePlayerAction(participantId: id, teamIndex: 0));
  }
  for (final id in ['b1', 'b2']) {
    game.dispatch(TogglePlayerAction(participantId: id, teamIndex: 1));
  }
  game.dispatch(ConfirmLineupAction(pullingTeamId: 'team1'));
  game.dispatch(SelectPullerAction(match.teams[0].participants.first));
  game.dispatch(SelectTakerAction(match.teams[1].participants.first));
  game.dispatch(PassToAction(match.teams[1].participants.last));
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
  final undoCalls = <String>[];

  @override
  Future<void> addEvent(CreateEventParams params) async =>
      events.add(params.event);

  @override
  Future<List<Event>> getEvents(String matchId) async => List.of(events);

  @override
  Future<Event> undoLastEvent(String matchId) async {
    undoCalls.add(matchId);
    return events.removeLast();
  }

  @override
  Future<void> updateEvent(UpdateEventParams params) =>
      throw UnimplementedError();

  @override
  Future<void> deleteEvent(String matchId, String eventId) =>
      throw UnimplementedError();
}
