import 'package:flutter/material.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';

class EventButton extends StatelessWidget {
  const EventButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.compact = false,
  });

  final String text;
  final VoidCallback onPressed;

  /// Уменьшенные отступы для рядов с несколькими действиями.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final radius = 8.0;
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(radius)
      ),
      child: AppInkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onPressed,
        child: Padding(
          padding: compact
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8)
              : const EdgeInsets.all(16.0),
          child: Text(text, style: theme.textTheme.labelSmall),
        ),
      ),
    );
  }
}
