import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_notifier.dart';

class MatchUndoBar extends ConsumerWidget {
  const MatchUndoBar({super.key, required this.match});

  final MatchDetail match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(matchGameProvider(match));
    final notifier = ref.read(matchGameProvider(match).notifier);
    final theme = Theme.of(context);
    final style = TextButton.styleFrom(
      foregroundColor: theme.colorScheme.onPrimary,
      disabledForegroundColor: theme.colorScheme.onPrimary.withValues(
        alpha: 0.4,
      ),
      textStyle: theme.textTheme.labelMedium,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            style: style,
            onPressed: notifier.canUndo ? notifier.undoLastAction : null,
            icon: const Icon(Icons.undo),
            label: const Text('Отменить действие'),
          ),
        ),
        if (notifier.isBusy) const LinearProgressIndicator(),
        if (notifier.message case final message?)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(message, style: theme.textTheme.displaySmall),
          ),
        if (notifier.canCheckPendingAction)
          TextButton.icon(
            style: style,
            onPressed: notifier.checkPendingAction,
            icon: const Icon(Icons.refresh),
            label: const Text('Проверить отмену'),
          ),
      ],
    );
  }
}
