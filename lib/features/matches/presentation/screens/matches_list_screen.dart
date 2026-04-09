import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_list_state.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_providers.dart';
import 'package:ultistats/features/matches/presentation/widgets/loading_matches_list_widget.dart';
import 'package:ultistats/features/matches/presentation/widgets/matches_list_widget.dart';
import 'package:ultistats/features/matches/presentation/widgets/no_matches_widget.dart';

@RoutePage()
class MatchesListScreen extends ConsumerWidget {
  const MatchesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(matchesListProvider);

    return ScreenWrapper(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 200),
        child: switch (state) {
          MatchesListLoading() => LoadingMatchesListWidget(key: ValueKey(1)),
          MatchesListError(:final exception, :final stackTrace) => ErrorScreen(
            key: ValueKey(2),
            exception: exception,
            stackTrace: stackTrace,
            onRetry: () => ref.read(matchesListProvider.notifier).loadInitial(),
          ),
          MatchesListLoaded(:final matches) when matches.isEmpty =>
            const NoMatchesWidget(key: ValueKey(3)),
          MatchesListLoaded() => MatchesListWidget(
            key: ValueKey(4),
            state: state,
          ),
        },
      ),
    );
  }
}
