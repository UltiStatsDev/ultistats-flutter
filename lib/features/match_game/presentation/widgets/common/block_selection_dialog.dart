import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/match_game/domain/match_action.dart';
import 'package:ultistats/features/match_game/presentation/widgets/common/player_selection_dialog.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';

/// Результат диалога блока: кто заблокировал и какой это был блок.
class BlockSelection {
  const BlockSelection({required this.blocker, required this.kind});

  final MatchParticipant blocker;
  final BlockKind kind;
}

/// Диалог выбора защитника, поставившего блок, и вида блока.
class BlockSelectionDialog extends StatefulWidget {
  const BlockSelectionDialog({super.key, required this.players});

  final List<MatchParticipant> players;

  static Future<BlockSelection?> show(
    BuildContext context, {
    required List<MatchParticipant> players,
  }) {
    return showDialog<BlockSelection>(
      context: context,
      builder: (context) => BlockSelectionDialog(players: players),
    );
  }

  @override
  State<BlockSelectionDialog> createState() => _BlockSelectionDialogState();
}

class _BlockSelectionDialogState extends State<BlockSelectionDialog> {
  BlockKind _kind = BlockKind.unspecified;

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
            Text("Кто заблокировал бросок?", style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildKindChip(context, BlockKind.unspecified, "Без уточнения"),
                _buildKindChip(context, BlockKind.marker, "Маркер"),
                _buildKindChip(context, BlockKind.field, "Поле"),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.players.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final player = widget.players[index];
                  return PlayerTile(
                    player: player,
                    onTap: () => Navigator.of(
                      context,
                    ).pop(BlockSelection(blocker: player, kind: _kind)),
                  );
                },
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

  Widget _buildKindChip(BuildContext context, BlockKind kind, String label) {
    final theme = Theme.of(context);
    final isSelected = _kind == kind;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _kind = kind),
      labelStyle: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      checkmarkColor: theme.colorScheme.primary,
      side: BorderSide.none,
    );
  }
}
