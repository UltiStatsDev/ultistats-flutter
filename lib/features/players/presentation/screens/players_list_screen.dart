import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/players/presentation/providers/players_list_state.dart';
import 'package:ultistats/features/players/presentation/widgets/players_list/loading_players_list_widget.dart';
import 'package:ultistats/features/players/presentation/widgets/players_list/no_players_widget.dart';
import 'package:ultistats/features/players/presentation/widgets/players_list/players_list_widget.dart';

import '../providers/players_list_notifier.dart';

@RoutePage()
class PlayersListScreen extends ConsumerWidget {
  const PlayersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playersListProvider);

    return ScreenWrapper(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 200),
        child: switch (state) {
          PlayersListLoading() => const LoadingPlayersListWidget(
              key: ValueKey(1),
            ),
          PlayersListError(:final exception, :final stackTrace) => ErrorScreen(
              key: const ValueKey(2),
              exception: exception,
              stackTrace: stackTrace,
              onRetry: () => ref.read(playersListProvider.notifier).loadInitial(),
            ),
          PlayersListLoaded(:final players) when players.isEmpty =>
            const NoPlayersWidget(key: ValueKey(3)),
          PlayersListLoaded() => PlayersListWidget(
              key: const ValueKey(4),
              state: state,
            ),
        },
      ),
    );
  }
}
