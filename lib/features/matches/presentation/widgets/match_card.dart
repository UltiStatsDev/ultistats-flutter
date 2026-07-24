import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';
import 'package:ultistats/core/widgets/photo_widget.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_list_item.dart';

class MatchCard extends StatelessWidget {
  final MatchListItem match;
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
                    child: Text(
                      match.status == MatchStatus.planned
                          ? "- : -"
                          : "${match.teams.first.teamScore}:${match.teams[1].teamScore}",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatDate(
                            match.status == MatchStatus.planned
                                ? match.plannedStartTimestamp
                                : match.startedAt,
                          ),
                          style: theme.textTheme.labelSmall,
                        ),
                        Text(
                          _formatTime(
                            match.status == MatchStatus.planned
                                ? match.plannedStartTimestamp
                                : match.startedAt,
                          ),
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildTeam(context, match.teams[1])),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) =>
      date != null ? DateFormat('dd.MM.yyyy').format(date) : '---';

  String _formatTime(DateTime? date) =>
      date != null ? DateFormat('HH:mm').format(date) : '---';

  Widget _buildTeam(BuildContext context, MatchListTeam team) {
    final theme = Theme.of(context);
    final photoSize = 80.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PhotoWidget(photoUrl: team.photoUrl, size: photoSize),
        SizedBox(height: 4),
        Text(
          team.teamName,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
