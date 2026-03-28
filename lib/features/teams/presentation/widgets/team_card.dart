import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';
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
      borderRadius: BorderRadius.circular(theme.teamCardBorderRadius),
      child: Ink(
        height: theme.teamCardHeight,
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(theme.teamCardBorderRadius),
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 12),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: photoSize,
                height: photoSize,
                child: Placeholder(),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    style: theme.textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    "Новосибирск",
                    style: theme.textTheme.bodyMedium,
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
