import 'package:auto_route/auto_route.dart';
import 'package:ultistats/features/matches/presentation/screens/match_screen.dart';
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
          page: MatchesTabRoute.page,
          path: "matches",
          initial: true,
          children: [
            CustomRoute(page: MatchesListRoute.page, path: "", initial: true),
            CustomRoute(
              page: EditMatchRoute.page,
              path: "edit",
              duration: Duration(seconds: 0),
              reverseDuration: Duration(seconds: 0),
            ),
            CustomRoute(
              page: MatchDetailRoute.page,
              path: "match_detail/:matchId",
              duration: Duration(seconds: 0),
              reverseDuration: Duration(seconds: 0),
            ),
          ],
        ),

        CustomRoute(
          page: TeamsTabRoute.page,
          path: "teams",
          children: [
            CustomRoute(page: TeamsListRoute.page, path: "", initial: true),
            CustomRoute(
              page: EditTeamRoute.page,
              path: "edit",
              duration: Duration(seconds: 0),
              reverseDuration: Duration(seconds: 0),
            ),
            CustomRoute(
              page: TeamDetailRoute.page,
              path: "team_detail/:teamId",
              duration: Duration(seconds: 0),
              reverseDuration: Duration(seconds: 0),
            ),
          ],
        ),

        CustomRoute(
          page: PlayersTabRoute.page,
          path: "players",
          children: [
            CustomRoute(page: PlayersListRoute.page, path: "", initial: true),
            CustomRoute(
              page: EditPlayerRoute.page,
              path: "edit",
              duration: Duration(seconds: 0),
              reverseDuration: Duration(seconds: 0),
            ),
            CustomRoute(
              page: PlayerDetailRoute.page,
              path: "player_detail/:playerId",
              duration: Duration(seconds: 0),
              reverseDuration: Duration(seconds: 0),
            ),
          ],
        ),
      ],
    ),
    AutoRoute(page: MatchRoute.page, path: "/match"),
  ];
}
