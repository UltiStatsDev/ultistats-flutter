import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/match_detail/loading_match_detail_widget.dart';
import 'package:ultistats/features/matches/presentation/widgets/match_detail/match_detail_widget.dart';
import 'package:ultistats/router/app_router.gr.dart';

@RoutePage()
class MatchDetailScreen extends ConsumerWidget {
  const MatchDetailScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen(matchDetailProvider(matchId), (previous, next) {
      if (next is MatchDetailLoaded &&
          next.match.status == MatchStatus.inProgress) {
        context.router.push(MatchRoute(match: next.match));
      }
    });

    final state = ref.watch(matchDetailProvider(matchId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ScreenWrapper(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: switch (state) {
            MatchDetailInitial() || MatchDetailLoading() =>
              const LoadingMatchDetailWidget(key: ValueKey(1)),
            MatchDetailError(:final exception, :final stackTrace) => ErrorScreen(
                key: const ValueKey(2),
                exception: exception,
                stackTrace: stackTrace,
                onRetry: () => ref
                    .read(matchDetailProvider(matchId).notifier)
                    .refresh(),
              ),
            MatchDetailLoaded() => MatchDetailWidget(
                key: const ValueKey(3),
                state: state,
              ),
          },
        ),
      ),
    );
  }
}
