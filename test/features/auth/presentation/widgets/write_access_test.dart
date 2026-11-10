import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/auth/presentation/providers/auth_controller.dart';
import 'package:ultistats/features/players/presentation/widgets/players_list/no_players_widget.dart';

void main() {
  testWidgets('гость не видит кнопку создания игрока', (tester) async {
    await tester.pumpWidget(_app(const NoPlayersWidget(), canWrite: false));

    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.text('Нет игроков'), findsOneWidget);
  });

  testWidgets('пользователь с правом записи видит создание игрока', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const NoPlayersWidget(), canWrite: true));

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}

Widget _app(Widget child, {required bool canWrite}) {
  return ProviderScope(
    overrides: [canWriteSportsProvider.overrideWithValue(canWrite)],
    child: MaterialApp(
      theme: createLightTheme(),
      home: Scaffold(body: child),
    ),
  );
}
