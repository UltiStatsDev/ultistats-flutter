import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/core/widgets/search_filter_bar.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_list_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_list_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/match_list/loading_matches_list_widget.dart';
import 'package:ultistats/features/matches/presentation/widgets/match_list/matches_list_widget.dart';
import 'package:ultistats/features/matches/presentation/widgets/match_list/no_matches_widget.dart';

@RoutePage()
class MatchesListScreen extends ConsumerWidget {
  const MatchesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(matchesListProvider);

    return ScreenWrapper(
      child: Column(
        children: [
          SearchFilterBar(
            onChanged: (value) =>
                ref.read(matchesListProvider.notifier).onSearchChanged(value),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              reverseDuration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: switch (state) {
                MatchesListLoading() => const LoadingMatchesListWidget(key: ValueKey(1)),
                MatchesListError(:final exception, :final stackTrace) => ErrorScreen(
                    key: const ValueKey(2),
                    exception: exception,
                    stackTrace: stackTrace,
                    onRetry: () =>
                        ref.read(matchesListProvider.notifier).loadInitial(),
                  ),
                MatchesListLoaded(:final matches) when matches.isEmpty =>
                  const NoMatchesWidget(key: ValueKey(3)),
                MatchesListLoaded() =>
                  MatchesListWidget(key: const ValueKey(4), state: state),
              },
            ),
          ),
        ],
      ),
    );
  }
}
