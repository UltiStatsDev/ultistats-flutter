import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/matches/presentation/providers/game/match_game_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/game/match_game_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/event_button.dart';

class TakerSelectionWidget extends ConsumerWidget {
  const TakerSelectionWidget({super.key, required this.state});

  final GameStateTakerSelection state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(matchGameProvider(state.match).notifier);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Кто принимает диск? (${state.activeTeam.name})",
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: theme.screenPadding),
            itemCount: state.activeTeamLineup.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final player = state.activeTeamLineup[index];
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      player.displayName,
                      style: theme.textTheme.displayMedium,
                    ),
                  ),
                  EventButton(
                    onPressed: () {
                      notifier.selectTaker(player);
                    },
                    text: "TAKE",
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
