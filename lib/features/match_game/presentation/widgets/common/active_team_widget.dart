import 'package:flutter/material.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';

class ActiveTeamWidget extends StatelessWidget {
  const ActiveTeamWidget({super.key, required this.team});

  final MatchTeam team;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(team.name, style: theme.textTheme.labelMedium,)
    );
  }
}
