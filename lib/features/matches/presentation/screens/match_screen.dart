import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/lineup_selection_widget.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/loading_widget.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/playing_widget.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/puller_selection_widget.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/taker_selection_widget.dart';

@RoutePage()
class MatchScreen extends ConsumerWidget {
  const MatchScreen({super.key, required this.match});

  final MatchDetail match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(matchGameProvider(match));

    ref.listen(matchGameProvider(match), (previous, next) {
      if (next is GameStateFinished) {
        context.router.pop();
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ScreenWrapper(child: _buildBody(state)),
    );
  }

  Widget _buildBody(MatchGameState state) {
    return switch (state) {
      GameStateError(:final exception, :final stackTrace) => ErrorScreen(
        exception: exception,
        stackTrace: stackTrace,
      ),
      GameStateLineupSelection() => LineupSelectionWidget(state: state),
      GameStatePullerSelection() => PullerSelectionWidget(state: state),
      GameStateTakerSelection() => TakerSelectionWidget(state: state),
      GameStatePlaying() => PlayingWidget(state: state),
      GameStateFinished() => LoadingWidget(),
      _ => throw UnimplementedError(),
    };
  }
}
