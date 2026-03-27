import 'package:auto_route/auto_route.dart';
import 'package:ultistats/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: DashboardRoute.page,
      path: '/dashboard',
      initial: true,
      children: [
        CustomRoute(
          page: MatchesListRoute.page,
          path: "matches",
          initial: true,
        ),
        CustomRoute(
          page: TeamsListRoute.page,
          path: "teams",
        ),
        CustomRoute(
          page: PlayersListRoute.page,
          path: "players",
        ),
      ],
    ),
  ];
}
