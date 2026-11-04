import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/domain/entities/page.dart' as app;
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/match_game/presentation/providers/match_game_notifier.dart';
import 'package:ultistats/features/match_game/presentation/screens/match_game_screen.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_list_item.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';
import 'package:ultistats/features/matches/domain/params/update_event_params.dart';
import 'package:ultistats/features/matches/domain/params/update_match_params.dart';
import 'package:ultistats/features/matches/domain/repositories/match_events_repository.dart';
import 'package:ultistats/features/matches/domain/repositories/matches_repository.dart';

void main() {
  testWidgets('пока события отправляются, показан экран «Завершаем матч»', (
    tester,
  ) async {
    final eventsRepository = _GatedEventsRepository();
    final match = _match();
    final container = ProviderContainer(
      overrides: [
        matchEventsRepositoryProvider.overrideWithValue(eventsRepository),
        matchesRepositoryProvider.overrideWithValue(
          _FakeMatchesRepository(match),
        ),
      ],
    );
    // Порядок важен: сначала освобождаем контейнер, потом отпускаем очередь,
    // иначе notifier попробует поп-нуть экран без AutoRouter-а.
    addTearDown(() => eventsRepository.gate?.complete());
    addTearDown(container.dispose);
    container.listen(matchGameProvider(match), (_, _) {});
    await tester.pump();

    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: createLightTheme(),
          home: const Scaffold(body: Text('Детали матча')),
        ),
      ),
    );
    navigatorKey.currentState!.push<void>(
      MaterialPageRoute(builder: (_) => MatchGameScreen(match: match)),
    );
    await tester.pumpAndSettle();

    eventsRepository.gate = Completer<void>();
    container
        .read(matchEventQueueProvider)
        .enqueue(match.id, MatchEvent.halftimeStart());

    unawaited(container.read(matchGameProvider(match).notifier).finishMatch());
    await tester.pump();

    expect(find.text('Завершаем матч'), findsOneWidget);
    expect(find.byType(MatchGameScreen), findsOneWidget);
    expect(find.text('Детали матча'), findsNothing);
  });
}

MatchDetail _match() {
  MatchParticipant player(String id) => MatchParticipant(
    participantId: id,
    kind: ParticipantKind.player,
    firstName: null,
    lastName: null,
    displayName: id,
    number: null,
    photoUrl: null,
  );

  return MatchDetail(
    id: 'match-1',
    teams: [
      MatchTeam(
        id: 'team-1',
        name: 'Team One',
        score: 0,
        participants: [player('a1'), player('a2')],
      ),
      MatchTeam(
        id: 'team-2',
        name: 'Team Two',
        score: 0,
        participants: [player('b1'), player('b2')],
      ),
    ],
    eventCount: 0,
    playersPerTeam: 2,
    status: MatchStatus.inProgress,
  );
}

class _GatedEventsRepository implements MatchEventsRepository {
  Completer<void>? gate;

  @override
  Future<List<Event>> getEvents(String matchId) async => const [];

  @override
  Future<void> addEvent(CreateEventParams params) async {
    await gate?.future;
  }

  @override
  Future<Event> undoLastEvent(String matchId) async =>
      MatchEvent.halftimeStart();

  @override
  Future<void> updateEvent(UpdateEventParams params) async {}

  @override
  Future<void> deleteEvent(String matchId, String eventId) async {}
}

class _FakeMatchesRepository implements MatchesRepository {
  _FakeMatchesRepository(this.match);

  final MatchDetail match;

  @override
  Future<app.Page<MatchListItem>> getList(MatchFilterParams params) async {
    throw UnimplementedError();
  }

  @override
  Future<void> createMatch(CreateMatchParams params) async {}

  @override
  Future<MatchDetail> getById(String matchId) async => match;

  @override
  Future<void> updateById(UpdateMatchParams params) async {}

  @override
  Future<void> deleteById(String matchId) async {}

  @override
  Future<MatchDetail> startMatch(String matchId, DateTime date) async => match;

  @override
  Future<MatchDetail> endMatch(String matchId, DateTime date) async => match;
}
