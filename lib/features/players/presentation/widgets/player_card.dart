import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';
import 'package:ultistats/core/widgets/photo_widget.dart';
import 'package:ultistats/features/players/domain/entities/player.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({super.key, required this.player, required this.onPressed});

  final Player player;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(theme.cardBorderRadius);
    final photoSize = 92.0;

    final teamName = "НИИ ТУДА";
    final number = player.number != null ? "#${player.number}" : "";

    return AppInkWell(
      onTap: onPressed,
      borderRadius: borderRadius,
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
            //TODO поставить юрл игрока потом как серв будет готов\
            PhotoWidget(photoUrl: "url", size: photoSize),
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
                  Row(
                    children: [
                      Text(
                        teamName,
                        style: theme.textTheme.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 6),
                      Text(
                        number,
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
