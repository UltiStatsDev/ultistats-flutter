import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_notifier.dart';

class TimeoutDialog extends ConsumerStatefulWidget {
  const TimeoutDialog({
    super.key,
    required this.match,
    required this.team,
  });

  final MatchDetail match;
  final MatchTeam team;

  static Future<void> show({
    required BuildContext context,
    required MatchDetail match,
    required MatchTeam team,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TimeoutDialog(match: match, team: team),
    );
  }

  @override
  ConsumerState<TimeoutDialog> createState() => _TimeoutDialogState();
}

class _TimeoutDialogState extends ConsumerState<TimeoutDialog> {
  late DateTime _startTime;
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed = DateTime.now().difference(_startTime);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.cardBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ТАЙМАУТ",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.primaryColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.team.name,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                _formatDuration(_elapsed),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 64,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("ЗАВЕРШИТЬ ТАЙМАУТ"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
