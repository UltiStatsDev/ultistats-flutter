import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_state.dart';
import 'package:ultistats/features/matches/presentation/widgets/match/common/pause_widget.dart';

class HalftimeWidget extends ConsumerWidget {
  const HalftimeWidget({super.key, required this.state});

  final GameStateHalftime state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(matchGameProvider(state.match).notifier);

    return PauseWidget(
      startedAt: state.startedAt,
      title: 'ПЕРЕРЫВ',
      subtitle: 'Между половинами',
      finishLabel: 'ЗАВЕРШИТЬ ПЕРЕРЫВ',
      onFinish: notifier.endHalftime,
    );
  }
}
