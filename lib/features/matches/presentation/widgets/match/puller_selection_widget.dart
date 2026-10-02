import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/common/active_team_widget.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/common/event_button.dart';

class PullerSelectionWidget extends ConsumerWidget {
  const PullerSelectionWidget({super.key, required this.state});

  final GameStatePullerSelection state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(matchGameProvider(state.match).notifier);

    return Column(
      children: [
        SizedBox(width: double.infinity, child: ActiveTeamWidget(team: state.activeTeam)),
        SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: state.activeTeamLineup.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final player = state.activeTeamLineup[index];
              return Row(
                children: [

                  Expanded(
                    child: Text(
                      player.displayName,
                      style: theme.textTheme.displayMedium
                    ),
                  ),
                  EventButton(
                    onPressed: () {
                      notifier.selectPuller(player);
                    },
                    text: "PULL",
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
