import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';

/// Диалог выбора игрока из состава команды.
class PlayerSelectionDialog extends StatelessWidget {
  const PlayerSelectionDialog({
    super.key,
    required this.title,
    required this.players,
  });

  final String title;
  final List<MatchParticipant> players;

  static Future<MatchParticipant?> show(
    BuildContext context, {
    required String title,
    required List<MatchParticipant> players,
  }) {
    return showDialog<MatchParticipant>(
      context: context,
      builder: (context) =>
          PlayerSelectionDialog(title: title, players: players),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: players.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) => PlayerTile(
                  player: players[index],
                  onTap: () => Navigator.of(context).pop(players[index]),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Отмена",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerTile extends StatelessWidget {
  const PlayerTile({super.key, required this.player, required this.onTap});

  final MatchParticipant player;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final number = player.number;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(theme.cardBorderRadius),
      ),
      child: AppInkWell(
        borderRadius: BorderRadius.circular(theme.cardBorderRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  number == null
                      ? player.displayName
                      : "${player.displayName} #$number",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
