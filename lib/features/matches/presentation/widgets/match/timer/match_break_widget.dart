import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_state.dart';

/// Kept on the match screen so an active or restored break can also be undone.
class MatchBreakWidget extends ConsumerStatefulWidget {
  const MatchBreakWidget({super.key, required this.state});

  final GameStateBreak state;

  @override
  ConsumerState<MatchBreakWidget> createState() => _MatchBreakWidgetState();
}

class _MatchBreakWidgetState extends ConsumerState<MatchBreakWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final elapsed = DateTime.now().difference(state.startedAt);
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    final theme = Theme.of(context);
    ref.watch(matchGameProvider(state.match));
    final notifier = ref.read(matchGameProvider(state.match).notifier);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.team == null ? 'ПЕРЕРЫВ' : 'ТАЙМАУТ',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.team?.name ?? 'Между половинами',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Text(
              '$minutes:$seconds',
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 56),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: !notifier.canInteract
                  ? null
                  : () {
                      final team = state.team;
                      if (team == null) {
                        notifier.endHalftime();
                      } else {
                        notifier.endTimeout(team);
                      }
                    },
              child: Text(
                state.team == null ? 'ЗАВЕРШИТЬ ПЕРЕРЫВ' : 'ЗАВЕРШИТЬ ТАЙМАУТ',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
