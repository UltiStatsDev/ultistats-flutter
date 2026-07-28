import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_list_notifier.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_list_state.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_list/loading_teams_list_widget.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_list/no_teams_widget.dart';
import 'package:ultistats/features/teams/presentation/widgets/team_list/teams_list_widget.dart';

@RoutePage()
class TeamsListScreen extends ConsumerWidget {
  const TeamsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teamsListProvider);

    return ScreenWrapper(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 200),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: switch (state) {
          TeamsListLoading() => LoadingTeamsListWidget(key: ValueKey(1)),
          TeamsListError(:final exception, :final stackTrace) => ErrorScreen(
            key: ValueKey(2),
            exception: exception,
            stackTrace: stackTrace,
            onRetry: () => ref.read(teamsListProvider.notifier).loadInitial(),
          ),
          TeamsListLoaded(:final teams) when teams.isEmpty =>
            const NoTeamsWidget(key: ValueKey(3)),
          TeamsListLoaded() => TeamsListWidget(key: ValueKey(4), state: state),
        },
      ),
    );
  }
}
