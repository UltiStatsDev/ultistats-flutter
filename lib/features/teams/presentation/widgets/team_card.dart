import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';
import 'package:ultistats/core/widgets/team_photo.dart';
import 'package:ultistats/features/teams/domain/entities/team.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({super.key, required this.team, required this.onPressed});

  final Team team;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photoSize = 92.0;
    return AppInkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(theme.cardBorderRadius),
      child: Ink(
        height: theme.cardHeight,
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(theme.cardBorderRadius),
          boxShadow: theme.cardBoxShadow,
        ),
        child: Row(
          children: [
            TeamPhoto(photoUrl: team.photoUrl, size: photoSize),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    team.city ?? "",
                    style: theme.textTheme.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
