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
    this.isProcessing = false,
  });

  final TeamPlayer player;
  final VoidCallback onPressed;
  final VoidCallback onDelete;
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: SizedBox(
                        width: 28,
                        child: Center(
                          child: Text(
                            player.number?.toString() ?? "---",
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(
                      text: "${player.firstName} ${player.lastName}",
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
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
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete,
                  color: theme.textTheme.labelMedium?.color,
                ),
                iconSize: 24,
              ),
          ],
        ),
      ),
    );
  }
}
