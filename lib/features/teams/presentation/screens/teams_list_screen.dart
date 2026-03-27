import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/teams/domain/entities/team.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_card.dart';

@RoutePage()
class TeamsListScreen extends StatelessWidget {
  const TeamsListScreen({super.key});

  static const _dummyTeams = [
    Team(id: '1', name: 'Sky Pro', players: []),
    Team(id: '2', name: 'Ultimate Warriors', players: []),
    Team(id: '3', name: 'Disk Catchers', players: []),
    Team(id: '4', name: 'Wind Walkers', players: []),
    Team(id: '5', name: 'Flyers United', players: []),
    Team(id: '6', name: 'Storm Bringers', players: []),
    Team(id: '7', name: 'Thunder Birds', players: []),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: EdgeInsets.only(bottom: theme.screenPadding),
      itemCount: _dummyTeams.length,
      itemBuilder: (context, index) {
        return TeamCard(team: _dummyTeams[index]);
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 12);
      },
    );
  }
}
