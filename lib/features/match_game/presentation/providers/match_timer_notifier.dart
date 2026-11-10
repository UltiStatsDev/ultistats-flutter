import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/logging/app_logger.dart';

part 'match_timer_notifier.g.dart';

class MatchTimerState {
  final Duration elapsed;
  final bool isRunning;

  const MatchTimerState({this.elapsed = Duration.zero, this.isRunning = false});

  MatchTimerState copyWith({Duration? elapsed, bool? isRunning}) {
    return MatchTimerState(
      elapsed: elapsed ?? this.elapsed,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

@riverpod
class MatchTimer extends _$MatchTimer {
  Timer? _timer;

  @override
  MatchTimerState build(String matchId) {
    ref.onDispose(() => _timer?.cancel());
    return const MatchTimerState();
  }

  void start({Duration? initialDuration}) {
    if (state.isRunning) return;

    log(
      'Starting match timer for $matchId'
      '${initialDuration == null ? '' : ' at ${initialDuration.inSeconds}s'}',
      name: runtimeType.toString(),
      level: AppLogLevel.debug,
    );

    if (initialDuration != null) {
      state = state.copyWith(elapsed: initialDuration);
    }

    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(
        elapsed: state.elapsed + const Duration(seconds: 1),
      );
    });
  }

  void pause() {
    log(
      'Pausing match timer for $matchId',
      name: runtimeType.toString(),
      level: AppLogLevel.debug,
    );
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    log(
      'Resetting match timer for $matchId',
      name: runtimeType.toString(),
      level: AppLogLevel.debug,
    );
    _timer?.cancel();
    _timer = null;
    state = const MatchTimerState();
  }
}
