import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ultistats/features/dashboard/presentation/widgets/dashboard_body.dart';
import 'package:ultistats/router/app_router.gr.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final _routes = [PlayersListRoute(), MatchesListRoute(), TeamsListRoute()];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: _routes,
      builder: (context, child) {
        return Scaffold(
          body: DashboardBody(child: child),
        );
      },
    );
  }
}
