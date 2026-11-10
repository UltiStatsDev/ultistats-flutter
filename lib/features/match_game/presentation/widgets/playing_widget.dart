import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/match_game/domain/match_game_state.dart';
import 'package:ultistats/features/match_game/domain/match_action.dart';
import 'package:ultistats/features/match_game/presentation/providers/match_game_notifier.dart';
import 'package:ultistats/features/match_game/presentation/widgets/common/active_team_widget.dart';
import 'package:ultistats/features/match_game/presentation/widgets/common/block_selection_dialog.dart';
import 'package:ultistats/features/match_game/presentation/widgets/common/event_button.dart';
import 'package:ultistats/features/match_game/presentation/widgets/common/player_selection_dialog.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';

class PlayingWidget extends ConsumerWidget {
  const PlayingWidget({super.key, required this.state});

  final GameStatePlaying state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(matchGameProvider(state.match).notifier);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ActiveTeamWidget(team: state.activeTeam),
        ),
        SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: state.activeTeamLineup.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final player = state.activeTeamLineup[index];
              final isThrower =
                  player.participantId == state.currentThrower.participantId;

              final actions = isThrower
                  ? _buildThrowerActions(context, ref, notifier)
                  : _buildReceiverActions(notifier, player);

              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      player.displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: isThrower ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 3,
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 6,
                      runSpacing: 6,
                      children: actions,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildReceiverActions(
    MatchGameNotifier notifier,
    MatchParticipant player,
  ) {
    return [
      EventButton(
        compact: true,
        onPressed: () => notifier.dispatch(PassToAction(player)),
        text: "PASS",
      ),
      EventButton(
        compact: true,
        onPressed: () => notifier.dispatch(ScoreGoalAction(player)),
        text: "GOAL",
      ),
    ];
  }

  List<Widget> _buildThrowerActions(
    BuildContext context,
    WidgetRef ref,
    MatchGameNotifier notifier,
  ) {
    return [
      EventButton(
        compact: true,
        onPressed: () => notifier.dispatch(const ThrowAwayAction()),
        text: "THROW",
      ),
      EventButton(
        compact: true,
        onPressed: () => _declareBlock(context, ref),
        text: "BLOCK",
      ),
      EventButton(
        compact: true,
        onPressed: () => _declareInterception(context, ref),
        text: "INTERCEPT",
      ),
      EventButton(
        compact: true,
        onPressed: () => _declareCallahan(context, ref),
        text: "CALLAHAN",
      ),
    ];
  }

  Future<void> _declareBlock(BuildContext context, WidgetRef ref) async {
    final selection = await BlockSelectionDialog.show(
      context,
      players: state.opponentTeamLineup,
    );
    if (selection == null || !context.mounted) return;

    ref
        .read(matchGameProvider(state.match).notifier)
        .dispatch(
          BlockAction(blocker: selection.blocker, kind: selection.kind),
        );
  }

  Future<void> _declareInterception(BuildContext context, WidgetRef ref) async {
    final interceptor = await PlayerSelectionDialog.show(
      context,
      title: "Кто перехватил пас?",
      players: state.opponentTeamLineup,
    );
    if (interceptor == null || !context.mounted) return;

    ref
        .read(matchGameProvider(state.match).notifier)
        .dispatch(InterceptionAction(interceptor));
  }

  Future<void> _declareCallahan(BuildContext context, WidgetRef ref) async {
    final interceptor = await PlayerSelectionDialog.show(
      context,
      title: "Кто сделал кэллахан?",
      players: state.opponentTeamLineup,
    );
    if (interceptor == null || !context.mounted) return;

    ref
        .read(matchGameProvider(state.match).notifier)
        .dispatch(CallahanAction(interceptor));
  }
}
