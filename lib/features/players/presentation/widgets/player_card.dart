import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';
import 'package:ultistats/core/widgets/photo_widget.dart';
import 'package:ultistats/features/players/domain/entities/player_list_item.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({super.key, required this.player, required this.onPressed});

  final PlayerListItem player;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photoSize = 92.0;
    final borderRadius = BorderRadius.circular(theme.cardBorderRadius);

    return AppInkWell(
      onTap: onPressed,
      borderRadius: borderRadius,
      child: Ink(
        height: theme.cardHeight,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(theme.cardBorderRadius),
          boxShadow: theme.cardBoxShadow,
        ),
        child: Row(
          children: [
            PhotoWidget(photoUrl: player.photoUrl, size: photoSize),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${player.firstName} ${player.lastName}',
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  if (player.teamName != null && player.number != null)
                    Row(
                      children: [
                        Text(
                          player.teamName!,
                          style: theme.textTheme.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "#${player.number}",
                          style: theme.textTheme.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
