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
    final foreground = theme.colorScheme.onPrimary;
    final buttonStyle = TextButton.styleFrom(
      foregroundColor: foreground,
      disabledForegroundColor: foreground.withValues(alpha: 0.4),
      textStyle: theme.textTheme.labelMedium,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            style: buttonStyle,
            onPressed: notifier.canUndo ? notifier.undoLastEvent : null,
            icon: const Icon(Icons.undo),
            label: const Text('Отменить событие'),
          ),
        ),
        if (notifier.isBusy) LinearProgressIndicator(color: foreground),
        if (notifier.message case final message?)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(color: foreground),
            ),
          ),
        if (notifier.canSynchronize)
          TextButton.icon(
            style: buttonStyle,
            onPressed: notifier.synchronize,
            icon: const Icon(Icons.refresh),
            label: const Text('Обновить состояние'),
          ),
      ],
    );
  }
}
