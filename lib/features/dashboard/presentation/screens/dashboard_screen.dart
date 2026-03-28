import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ultistats/features/dashboard/presentation/widgets/dashboard_body.dart';
import 'package:ultistats/router/app_router.gr.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final _routes = const [
    MatchesListRoute(),
    TeamsListRoute(),
    PlayersListRoute(),
  ];


  //TODO добавить pageView и разобраться
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: _routes,
      builder: (context, child, pageController) {
        return DashboardBody(child: child);
      },
    );
  }
}