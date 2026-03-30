import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';
import 'package:ultistats/core/widgets/team_photo.dart';
import 'package:ultistats/features/matches/domain/entities/match.dart';
import 'package:ultistats/features/teams/domain/entities/team.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final VoidCallback onPressed;

  const MatchCard({super.key, required this.match, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppInkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(theme.cardBorderRadius),
      child: Ink(
        height: theme.cardHeight,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(theme.cardBorderRadius),
          boxShadow: theme.cardBoxShadow,
        ),
        child: Row(
          children: [
            Expanded(child: _buildTeam(context, match.teams.first)),
            Expanded(
              child: Stack(
                children: [
                  Center(
                    //TODO апи поменяется и поменять эту штуку
                    child: Text("11:7", style: theme.textTheme.displayLarge),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _formatDate(match.status == MatchStatus.planned
                          ? match.plannedStartTimestamp
                          : match.startedAt),
                      style: theme.textTheme.displaySmall,
                    ),
                  ),
                ],
              ),
            ),
            // TODO переделать на чтото типа second
            Expanded(child: _buildTeam(context, match.teams.first)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) =>
      date != null ? DateFormat('dd.MM.yyyy').format(date) : '---';

  Widget _buildTeam(BuildContext context, Team team) {
    final theme = Theme.of(context);
    final photoSize = 80.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TeamPhoto(photoUrl: team.photoUrl, size: photoSize),
        SizedBox(height: 4),
        Text(
          team.name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
