import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail/match_detail_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail/match_detail_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/match_detail/loading_match_detail_widget.dart';
import 'package:ultistats/features/matches/presentation/widgets/match_detail/match_detail_widget.dart';
import 'package:ultistats/router/app_router.gr.dart';

@RoutePage()
class MatchDetailScreen extends ConsumerStatefulWidget {
  const MatchDetailScreen({super.key, required this.matchId});

  final String matchId;

  @override
  ConsumerState<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends ConsumerState<MatchDetailScreen> {
  bool _hasOpenedMatch = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(matchDetailProvider(widget.matchId), (previous, next) {
      if (!_hasOpenedMatch &&
          next is MatchDetailLoaded &&
          next.match.status == MatchStatus.inProgress &&
          ModalRoute.of(context)?.isCurrent == true &&
          context.router.root.topRoute.name == MatchDetailRoute.name) {
        _hasOpenedMatch = true;
        context.router.push(MatchRoute(match: next.match));
      }
    });

    final state = ref.watch(matchDetailProvider(widget.matchId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ScreenWrapper(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: switch (state) {
            MatchDetailInitial() || MatchDetailLoading() =>
              const LoadingMatchDetailWidget(key: ValueKey(1)),
            MatchDetailError(:final exception, :final stackTrace) =>
              ErrorScreen(
                key: const ValueKey(2),
                exception: exception,
                stackTrace: stackTrace,
                onRetry: () => ref
                    .read(matchDetailProvider(widget.matchId).notifier)
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
