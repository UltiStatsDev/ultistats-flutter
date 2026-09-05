import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/photo_widget.dart';
import 'package:ultistats/features/players/domain/entities/player_detail.dart';
import 'package:ultistats/features/players/presentation/widgets/player_detail/player_detail_app_bar.dart';

class PlayerDetailWidget extends StatelessWidget {
  const PlayerDetailWidget({super.key, required this.player});

  final PlayerDetail player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        PlayerDetailAppBar(
          onBackPressed: () {
            context.router.pop();
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhotoWidget(photoUrl: player.photoUrl, size: 120),
            const SizedBox(width: 12),
            Text("${player.firstName} ${player.lastName}",
              style: theme.textTheme.titleMedium,)
          ],
        ),
        Text("Asd")
      ],
    );
  }
}
