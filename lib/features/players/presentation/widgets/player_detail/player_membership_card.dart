import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';
import 'package:ultistats/features/players/domain/entities/player_membership.dart';

class PlayerMembershipCard extends StatelessWidget {
  const PlayerMembershipCard({
    super.key,
    required this.membership,
    required this.onPressed,
  });

  final PlayerMembership membership;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = theme.textFieldBorderRadius;

    return AppInkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Ink(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: Center(
                child: Text(
                  "#${membership.number}",
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            VerticalDivider(
              indent: 12,
              endIndent: 12,
              thickness: 1,
              color: theme.primaryColor.withValues(alpha: 0.1),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Команда ID: ${membership.teamId.substring(0, 8)}...",
                style: theme.textTheme.labelMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.primaryColor.withValues(alpha: 0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
