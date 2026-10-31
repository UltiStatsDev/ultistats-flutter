import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/repositories/matches_repository.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_notifier.dart';
import 'package:ultistats/router/app_router.gr.dart';

import 'match_single_undo_test.dart' show RecordingUndoRepository, participants;
import 'package:ultistats/features/matches/domain/entities/match_team.dart';

final testMatch = MatchDetail(
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

class _TestRouter extends RootStackRouter {
  _TestRouter({this.nested = false});
  final bool nested;
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: PageInfo(
        'Home',
        builder: (_) =>
            nested ? const AutoRouter() : const Scaffold(body: Text('Home')),
      ),
      path: '/',
      initial: true,
      children: nested
          ? [
              AutoRoute(
                page: PageInfo(
                  'List',
                  builder: (_) => const Scaffold(body: Text('List')),
                ),
                path: '',
                initial: true,
              ),
              AutoRoute(page: MatchDetailRoute.page),
            ]
          : [],
    ),
    if (!nested) AutoRoute(page: MatchDetailRoute.page),
    AutoRoute(page: MatchRoute.page),
  ];
}

class _Matches extends Fake implements MatchesRepository {
  MatchDetail match = testMatch;
  Completer<MatchDetail>? pendingRead;
  @override
  Future<MatchDetail> getById(String matchId) async =>
      pendingRead == null ? match : await pendingRead!.future;
  @override
  Future<MatchDetail> endMatch(String matchId, DateTime date) async =>
      match = match.copyWith(status: MatchStatus.finished);
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    final font = FontLoader('Montserrat')
      ..addFont(
        rootBundle.load('assets/fonts/Montserrat/Montserrat-Regular.ttf'),
      )
      ..addFont(rootBundle.load('assets/fonts/Montserrat/Montserrat-Bold.ttf'));
    await font.load();
  });
  Future<void> pumpRoutes(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 150));
    }
  }

  for (final scenario in [
    'undo refresh',
    'finish once',
    'break back',
    'nested detail refresh',
    'delayed refresh after leaving match',
  ]) {
    testWidgets(scenario, (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final nested = scenario == 'nested detail refresh';
      final router = _TestRouter(nested: nested);
      final matches = _Matches();
      final container = ProviderContainer(
        overrides: [
          matchesRepositoryProvider.overrideWithValue(matches),
          matchEventsRepositoryProvider.overrideWithValue(
            RecordingUndoRepository(),
          ),
        ],
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            locale: const Locale('en'),
            supportedLocales: const [Locale('en')],
            theme: createLightTheme(),
            routerConfig: router.config(),
          ),
        ),
      );
      await pumpRoutes(tester);
      if (nested) {
        router.navigate(
          PageRouteInfo(
            'Home',
            initialChildren: [
              const PageRouteInfo('List'),
              MatchDetailRoute(matchId: testMatch.id),
            ],
          ),
        );
      } else {
        router.push(MatchDetailRoute(matchId: testMatch.id));
      }
      await pumpRoutes(tester);
      expect(router.stack.map((p) => p.name), [
        'Home',
        if (!nested) MatchDetailRoute.name,
        MatchRoute.name,
      ]);
      final notifier = container.read(matchGameProvider(testMatch).notifier);
      if (scenario == 'finish once') {
        notifier.finishMatch();
        await pumpRoutes(tester);
        expect(router.stack.map((p) => p.name), [
          'Home',
          if (!nested) MatchDetailRoute.name,
        ]);
      } else if (scenario == 'delayed refresh after leaving match') {
        notifier.startHalftime();
        await tester.pump();
        matches.pendingRead = Completer<MatchDetail>();
        await notifier.undoLastAction();
        await tester.pump();
        await router.maybePop();
        await pumpRoutes(tester);
        expect(router.stack.map((p) => p.name), [
          'Home',
          MatchDetailRoute.name,
        ]);
        matches.pendingRead!.complete(matches.match);
        await pumpRoutes(tester);
        expect(router.stack.map((p) => p.name), [
          'Home',
          MatchDetailRoute.name,
        ]);
      } else {
        notifier.startHalftime();
        await tester.pump();
        notifier.endHalftime();
        await tester.pump();
        await notifier.undoLastAction();
        await pumpRoutes(tester);
        expect(router.stack.map((p) => p.name), [
          'Home',
          if (!nested) MatchDetailRoute.name,
          MatchRoute.name,
        ]);
        expect(find.text('ЗАВЕРШИТЬ ПЕРЕРЫВ'), findsOneWidget);
        if (scenario == 'break back') {
          await router.maybePop();
          await pumpRoutes(tester);
          expect(router.stack.last.name, MatchRoute.name);
        }
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      container.dispose();
      router.dispose();
    });
  }
}
