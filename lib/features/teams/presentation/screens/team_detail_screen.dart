import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/teams/presentation/providers/team_detail_notifier.dart';
import 'package:ultistats/features/teams/presentation/providers/team_detail_state.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_detail/loading_team_detail_widget.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_detail/team_detail_widget.dart';


@RoutePage()
class TeamDetailScreen extends ConsumerWidget {
  const TeamDetailScreen({super.key, required this.teamId});

  final String teamId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teamDetailProvider(teamId));

    return ScreenWrapper(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 200),
        child: switch (state) {

          TeamDetailInitial() || TeamDetailLoading() => LoadingTeamDetailWidget(),
          TeamDetailLoaded() => TeamDetailWidget(team: state.team),
          TeamDetailError() => ErrorScreen(
            exception: state.error,
            stackTrace: state.stackTrace,
            onRetry: () => ref.refresh(teamDetailProvider(teamId)),
            onBack: () => context.router.pop(),
          ),
        },
      ),
    );
  }
}
