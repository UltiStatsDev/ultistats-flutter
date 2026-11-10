import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/auth/presentation/widgets/auth_activity_listener.dart';
import 'package:ultistats/features/auth/presentation/widgets/auth_gate.dart';
import 'package:ultistats/router/app_router.dart';

class App extends ConsumerWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ru', 'RU'), Locale('en', 'US')],
      locale: const Locale('ru', 'RU'),
      theme: createLightTheme(),
      builder: (context, child) {
        return AuthActivityListener(
          child: AuthGate(child: child ?? const SizedBox.shrink()),
        );
      },
      routerConfig: _appRouter.config(),
    );
  }
}
