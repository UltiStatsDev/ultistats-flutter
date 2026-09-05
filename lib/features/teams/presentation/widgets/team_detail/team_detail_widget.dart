import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ultistats/core/widgets/photo_widget.dart';
import 'package:ultistats/features/teams/domain/entities/team_detail.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_detail/team_detail_app_bar.dart';

class TeamDetailWidget extends StatelessWidget {
  const TeamDetailWidget({super.key, required this.team});

  final TeamDetail team;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        TeamDetailAppBar(onBackPressed: () => context.router.pop()),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhotoWidget(photoUrl: team.photoUrl, size: 120),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(team.name, style: theme.textTheme.titleMedium),
                Text(team.city ?? "", style: theme.textTheme.titleSmall)
              ],
            )
          ],
        ),
      ],
    );
  }
}
