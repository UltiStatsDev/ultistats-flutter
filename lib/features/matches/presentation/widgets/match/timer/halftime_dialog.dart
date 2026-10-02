import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_notifier.dart';

class HalftimeDialog extends ConsumerStatefulWidget {
  const HalftimeDialog({
    super.key,
    required this.match,
  });

  final MatchDetail match;

  static Future<void> show({
    required BuildContext context,
    required MatchDetail match,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => HalftimeDialog(match: match),
    );
  }

  @override
  ConsumerState<HalftimeDialog> createState() => _HalftimeDialogState();
}

class _HalftimeDialogState extends ConsumerState<HalftimeDialog> {
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
      if (mounted) {
        setState(() {
          _elapsed = DateTime.now().difference(_startTime);
        });
      }
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
                "ПЕРЕРЫВ",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.primaryColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Между половинами",
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
                  child: const Text("ЗАВЕРШИТЬ ПЕРЕРЫВ"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
