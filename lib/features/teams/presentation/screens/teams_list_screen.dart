import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_list_state.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_providers.dart';
import 'package:ultistats/features/teams/presentation/widgets/loading_teams_list_widget.dart';
import 'package:ultistats/features/teams/presentation/widgets/no_teams_widget.dart';
import 'package:ultistats/features/teams/presentation/widgets/teams_list_widget.dart';

@RoutePage()
class TeamsListScreen extends ConsumerWidget {
  const TeamsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(teamsListProvider);

    return ScreenWrapper(
      child: switch (state) {
        TeamsListLoading() => LoadingTeamsListWidget(),
        TeamsListError(:final exception, :final stackTrace) => ErrorScreen(
          exception: exception,
          stackTrace: stackTrace,
          onRetry: () => ref.read(teamsListProvider.notifier).loadInitial(),
        ),
        TeamsListLoaded(:final teams) when teams.isEmpty =>
          const NoTeamsWidget(),
        TeamsListLoaded() => TeamsListWidget(state: state),
      },
    );
  }
}
