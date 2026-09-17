import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/dashboard/presentation/widgets/dashboard_body.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_list_notifier.dart';
import 'package:ultistats/features/players/presentation/providers/players_list_notifier.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_list_notifier.dart';
import 'package:ultistats/router/app_router.gr.dart';

@RoutePage()
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  final _routes = const [
    MatchesTabRoute(),
    TeamsTabRoute(),
    PlayersTabRoute(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // "Прогреваем" провайдеры списков, чтобы данные начали грузиться сразу.
    // Используем listen, чтобы сам Dashboard не перерисовывался лишний раз.
    ref.listen(matchesListProvider, (_, __) {});
    ref.listen(teamsListProvider, (_, __) {});
    ref.listen(playersListProvider, (_, __) {});

    return AutoTabsRouter.pageView(
      routes: _routes,
      builder: (context, child, pageController) {
        return DashboardBody(child: child);
      },
    );
  }
}
