import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/confirm_edit_button.dart';
import 'package:ultistats/features/matches/presentation/providers/match_preparation_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_preparation_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/match_preparation/match_preparation_app_bar.dart';
import 'package:ultistats/features/matches/presentation/widgets/match_preparation/player_select_card.dart';
import 'package:ultistats/features/teams/domain/entities/team_detail.dart';

class MatchPreparationWidget extends ConsumerWidget {
  const MatchPreparationWidget({super.key, required this.state});

  final MatchPreparationLoaded state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(
      matchPreparationProvider(state.match.id).notifier,
    );

    return Column(
      children: [
        MatchPreparationAppBar(
          title: "Подготовка состава",
          onBackPressed: () {
            context.router.pop();
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTeamSection(
                  context,
                  state.team1,
                  state.selectedPlayerIds1,
                  (playerId) {
                    notifier.togglePlayer(state.team1.id, playerId);
                  },
                  state.team1Warning,
                ),
                const SizedBox(height: 16),
                _buildTeamSection(
                  context,
                  state.team2,
                  state.selectedPlayerIds2,
                  (playerId) {
                    notifier.togglePlayer(state.team2.id, playerId);
                  },
                  state.team2Warning,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        if (state.isStarting)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        else
          ConfirmEditButton(
            confirmButtonText: "Начать матч",
            onTap: state.canStart && !state.isStarting
                ? () => notifier.startMatch()
                : null,
          ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTeamSection(
    BuildContext context,
    TeamDetail team,
    Set<String> selectedIds,
    Function(String) onToggle,
    PreparationWarning? warning,
  ) {
    String? parseWarning(PreparationWarning? warning) {
      return switch (warning) {
        null => null,
        PreparationWarning.needs5players => "Нужно минимум 5 игроков в команде",
        PreparationWarning.select5players => "Выберите 5 игроков",
      };
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(team.name, style: theme.textTheme.displayLarge),
            Text(
              "${selectedIds.length} / 5",
              style: theme.textTheme.titleSmall?.copyWith(
                color: selectedIds.length == 5 ? Colors.greenAccent : null,
              ),
            ),
          ],
        ),
        if (warning != null) ...[
          const SizedBox(height: 4),
          Text(
            parseWarning(warning)!,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.orangeAccent,
            ),
          ),
        ],
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: team.players.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 110
          ),
          itemBuilder: (context, index) {
            final player = team.players[index];
            final isSelected = selectedIds.contains(player.playerId);

            return PlayerSelectCard(
              player: player,
              isSelected: isSelected,
              onTap: () => onToggle(player.playerId),
            );
          },
        ),
      ],
    );
  }
}
