import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/photo_widget.dart';
import 'package:ultistats/features/teams/domain/entities/team_detail.dart';
import 'package:ultistats/features/teams/presentation/providers/team_detail_notifier.dart';
import 'package:ultistats/features/teams/presentation/providers/team_detail_state.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_detail/add_player_to_team_widget.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_detail/player_number_dialog.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_detail/team_detail_app_bar.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_detail/team_player_card.dart';
import 'package:ultistats/router/app_router.gr.dart';

class TeamDetailWidget extends ConsumerWidget {
  const TeamDetailWidget({super.key, required this.team});

  final TeamDetail team;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final state = ref.watch(teamDetailProvider(team.id));
    final processingIds = state is TeamDetailLoaded
        ? state.processingPlayerIds
        : const <String>{};

    return Column(
      children: [
        TeamDetailAppBar(onBackPressed: () => context.router.pop()),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: theme.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PhotoWidget(photoUrl: team.photoUrl, size: 120),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(team.name, style: theme.textTheme.titleMedium),
                          Text(
                            team.city ?? "",
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text("Игроки", style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: team.players.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final player = team.players[index];

                    return TeamPlayerCard(
                      player: player,
                      isProcessing: processingIds.contains(player.playerId),
                      onPressed: () {
                        context.navigateTo(
                          PlayersTabRoute(
                            children: [
                              const PlayersListRoute(),
                              PlayerDetailRoute(playerId: player.playerId),
                            ],
                          ),
                        );
                      },
                      onDelete: () {
                        ref
                            .read(teamDetailProvider(team.id).notifier)
                            .removePlayer(player.playerId);
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                AddPlayerToTeamWidget(
                  onPlayerSelected: (player) async {
                    final number = await PlayerNumberDialog.show(
                      context,
                      player,
                    );
                    if (number == null) return;

                    ref
                        .read(teamDetailProvider(team.id).notifier)
                        .addPlayer(player.id, number);
                  },
                  isProcessing: processingIds.any(
                    (procId) => !team.players.any((p) => p.playerId == procId),
                  ),
                  existingPlayerIds: team.players
                      .map((p) => p.playerId)
                      .toSet(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
