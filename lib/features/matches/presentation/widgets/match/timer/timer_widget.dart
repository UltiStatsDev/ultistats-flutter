import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_state.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_timer_notifier.dart';

class TimerWidget extends ConsumerWidget {
  const TimerWidget({super.key, required this.match});

  final MatchDetail match;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timerState = ref.watch(matchTimerProvider(match.id));
    final gameState = ref.watch(matchGameProvider(match));
    final notifier = ref.read(matchGameProvider(match).notifier);

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(theme.navBarBorderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Основное время
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ВРЕМЯ МАТЧА",
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatDuration(timerState.elapsed),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const Spacer(),
          _TimerButton(
            label: "T",
            onPressed: notifier.canInteract && gameState is GameStatePlaying
                ? () {
                    notifier.startTimeout(gameState.activeTeam);
                  }
                : null,
          ),
          const SizedBox(width: 12),
          _TimerButton(
            label: "HT",
            onPressed:
                notifier.canInteract && gameState is GameStateLineupSelection
                ? () {
                    notifier.startHalftime();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _TimerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _TimerButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 54,
      height: 44,
      child: Opacity(
        opacity: onPressed != null ? 1 : 0.5,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            side: BorderSide(color: theme.primaryColor, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: theme.primaryColor.withValues(alpha: 0.05),
          ),
          child: Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
