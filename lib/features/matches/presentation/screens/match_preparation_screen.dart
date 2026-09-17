import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/matches/presentation/providers/match_preparation_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_preparation_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/match_preparation/match_preparation_widget.dart';
import 'package:ultistats/router/app_router.gr.dart';

@RoutePage()
class MatchPreparationScreen extends ConsumerWidget {
  const MatchPreparationScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Слушаем успех старта матча для перехода
    ref.listen(matchPreparationProvider(matchId), (previous, next) {
      if (next is MatchPreparationLoaded && next.isSuccess) {
        context.router.replace(const MatchRoute());
      }
    });

    final state = ref.watch(matchPreparationProvider(matchId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ScreenWrapper(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: switch (state) {
            MatchPreparationLoading() => const Center(
                key: ValueKey(1),
                child: CircularProgressIndicator(),
              ),
            MatchPreparationError(:final error, :final stackTrace) => ErrorScreen(
                key: const ValueKey(2),
                exception: error,
                stackTrace: stackTrace,
              ),
            MatchPreparationLoaded() => MatchPreparationWidget(
                key: const ValueKey(3),
                state: state,
              ),
          },
        ),
      ),
    );
  }
}
