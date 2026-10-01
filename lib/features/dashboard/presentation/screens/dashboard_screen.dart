import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/dashboard/presentation/widgets/dashboard_body.dart';
import 'package:ultistats/features/matches/presentation/providers/match_list/matches_list_notifier.dart';
import 'package:ultistats/features/players/presentation/providers/player_list/players_list_notifier.dart';
import 'package:ultistats/features/teams/presentation/providers/team_list/teams_list_notifier.dart';
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
