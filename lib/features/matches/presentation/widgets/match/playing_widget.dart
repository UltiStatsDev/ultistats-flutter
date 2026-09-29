import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/matches/presentation/providers/game/match_game_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/game/match_game_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/common/event_button.dart';

class PlayingWidget extends ConsumerWidget {
  const PlayingWidget({super.key, required this.state});

  final GameStatePlaying state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(matchGameProvider(state.match).notifier);

    return Column(
      children: [
        Column(
          children: [
            Text(
              "Владение: ${state.activeTeam.name}",
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              "Диск у: ${state.currentThrower.displayName}",
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.primaryColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: theme.screenPadding),
            itemCount: state.activeTeamLineup.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final player = state.activeTeamLineup[index];
              final isThrower =
                  player.participantId == state.currentThrower.participantId;

              return Row(
                children: [
                  Expanded(
                    child: Text(
                      player.displayName,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: isThrower ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                  if (isThrower)
                    EventButton(
                      onPressed: () => notifier.turnover(),
                      text: "DROP",
                    )
                  else ...[
                    EventButton(
                      onPressed: () => notifier.passTo(player),
                      text: "PASS",
                    ),
                    const SizedBox(width: 8),
                    EventButton(
                      onPressed: () => notifier.scoreGoal(player),
                      text: "GOAL",
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
