import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';

class PauseWidget extends StatefulWidget {
  const PauseWidget({
    super.key,
    required this.startedAt,
    required this.title,
    required this.subtitle,
    required this.finishLabel,
    required this.onFinish,
  });

  final DateTime startedAt;
  final String title;
  final String subtitle;
  final String finishLabel;
  final VoidCallback onFinish;

  @override
  State<PauseWidget> createState() => _PauseWidgetState();
}

class _PauseWidgetState extends State<PauseWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatElapsed() {
    final elapsed = DateTime.now().difference(widget.startedAt);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(elapsed.inMinutes.remainder(60))}:'
        '${twoDigits(elapsed.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(theme.cardBorderRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.primaryColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.subtitle,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                _formatElapsed(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 64,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: widget.onFinish,
                  child: Text(widget.finishLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
