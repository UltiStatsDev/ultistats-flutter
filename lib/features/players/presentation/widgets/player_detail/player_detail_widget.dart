import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/photo_widget.dart';
import 'package:ultistats/features/players/presentation/providers/player_detail/player_detail_state.dart';
import 'package:ultistats/features/players/presentation/screens/edit_player_screen.dart';
import 'package:ultistats/features/players/presentation/widgets/player_detail/player_detail_app_bar.dart';
import 'package:ultistats/features/players/presentation/widgets/player_detail/player_membership_card.dart';
import 'package:ultistats/router/app_router.gr.dart';

class PlayerDetailWidget extends StatelessWidget {
  const PlayerDetailWidget({super.key, required this.state});

  final PlayerDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final player = state.player;
    return Column(
      children: [
        PlayerDetailAppBar(
          onBackPressed: () {
            context.router.pop();
          },
          onEditPressed: () {
            context.router.push(
              EditPlayerRoute(
                title: "Редактирование",
                confirmButtonText: "Сохранить",
                initialData: EditPlayerScreenInitial(
                  name: player.firstName,
                  secondName: player.lastName,
                  id: player.id,
                  photoUrl: player.photoUrl,
                ),
              ),
            );
          },
        ),
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
                    PhotoWidget(photoUrl: player.photoUrl, size: 120),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${player.firstName} ${player.lastName}",
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            "Игрок",
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text("Команды", style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                if (player.memberships.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        "Нет информации о командах",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: player.memberships.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final membership = player.memberships[index];
                      return PlayerMembershipCard(
                        membership: membership,
                        onPressed: () {
                          context.navigateTo(
                            TeamsTabRoute(
                              children: [
                                const TeamsListRoute(),
                                TeamDetailRoute(teamId: membership.teamId),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
