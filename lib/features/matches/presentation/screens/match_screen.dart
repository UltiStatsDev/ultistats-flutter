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
import 'package:ultistats/features/matches/presentation/widgets/match/timer/timer_widget.dart';

@RoutePage()
class MatchScreen extends ConsumerWidget {
  const MatchScreen({super.key, required this.match});

  final MatchDetail match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(matchGameProvider(match));

    ref.listen(matchGameProvider(match), (previous, next) {
      if (next is GameStateFinished) {
        context.router.pop();
      }
    });

    final team1 = state.match.teams[0];
    final team2 = state.match.teams[1];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ScreenWrapper(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    team1.name,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${team1.score}:${team2.score}",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    team2.name,
                    textAlign: TextAlign.start,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Expanded(child: _buildBody(state)),

            TimerWidget(match: match),
          ],
        ),
      ),
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
