import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/match_undo_bar.dart';

import 'match_game_undo_test.dart' show GameHarness, testMatch, playerB2;

void main() {
  testWidgets(
    'undo control follows pending writes and restores previous phase',
    (tester) async {
      final h = GameHarness();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: h.container,
          child: const MaterialApp(
            home: Scaffold(body: MatchUndoBar(match: testMatch)),
          ),
        ),
      );
      final button = find.widgetWithText(TextButton, 'Отменить событие');
      expect(tester.widget<TextButton>(button).onPressed, isNull);
      await tester.runAsync(h.play);
      await tester.pump();
      expect(tester.widget<TextButton>(button).onPressed, isNotNull);

      h.repository.undoGate = Completer<void>();
      await tester.tap(button);
      await tester.pump();
      expect(tester.widget<TextButton>(button).onPressed, isNull);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      h.repository.undoGate!.complete();
      await tester.pump();
      await tester.pump();
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(h.repository.events, hasLength(1));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      h.container.dispose();
    },
  );

  testWidgets('uncertain undo shows a read-only synchronization action', (
    tester,
  ) async {
    final h = GameHarness();
    await tester.runAsync(h.play);
    h.repository.loseUndoResponse = true;
    h.repository.failReadsAfterUndo = true;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: h.container,
        child: const MaterialApp(
          home: Scaffold(body: MatchUndoBar(match: testMatch)),
        ),
      ),
    );
    await tester.tap(find.text('Отменить событие'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Обновить состояние'), findsOneWidget);
    expect(h.notifier.canInteract, isFalse);
    h.notifier.passTo(playerB2);
    h.repository.failReadsAfterUndo = false;
    await tester.tap(find.text('Обновить состояние'));
    await tester.pump();
    await tester.pump();
    expect(h.notifier.canInteract, isTrue);
    expect(h.repository.undoCalls, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    h.container.dispose();
  });
}
