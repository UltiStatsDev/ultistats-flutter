import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/common/pause_widget.dart';

class TimeoutWidget extends ConsumerWidget {
  const TimeoutWidget({super.key, required this.state});

  final GameStateTimeout state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(matchGameProvider(state.match).notifier);

    return PauseWidget(
      startedAt: state.startedAt,
      title: 'ТАЙМАУТ',
      subtitle: state.team.name,
      finishLabel: 'ЗАВЕРШИТЬ ТАЙМАУТ',
      onFinish: () => notifier.endTimeout(state.team),
    );
  }
}
