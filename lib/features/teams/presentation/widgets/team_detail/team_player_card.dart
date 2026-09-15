import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';
import 'package:ultistats/features/players/domain/entities/team_player.dart';

class TeamPlayerCard extends StatelessWidget {
  const TeamPlayerCard({
    super.key,
    required this.player,
    required this.onPressed,
    required this.onDelete,
    required this.onEdit,
    this.isProcessing = false,
  });

  final TeamPlayer player;
  final VoidCallback onPressed;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = theme.textFieldBorderRadius;
    return AppInkWell(
      onTap: isProcessing ? () {} : onPressed,
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
                  "#${player.number?.toString() ?? "---"}",
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
                "${player.firstName} ${player.lastName}",
                style: theme.textTheme.labelMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (isProcessing)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: theme.primaryColor),
                ),
              )
            else
              ...[
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.numbers,
                    color: theme.textTheme.labelMedium?.color,
                  ),
                  iconSize: 24,
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete,
                    color: theme.textTheme.labelMedium?.color,
                  ),
                  iconSize: 24,
                ),
              ]

          ],
        ),
      ),
    );
  }
}
