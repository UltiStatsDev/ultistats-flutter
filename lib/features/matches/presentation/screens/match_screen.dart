import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/players_team_widget.dart';

@RoutePage()
class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ScreenWrapper(
        child: Column(
          children: [
            PlayersTeamWidget(),
            SizedBox(height: 10),
            PlayersTeamWidget(),
          ],
        ),
      ),
    );
  }
}
