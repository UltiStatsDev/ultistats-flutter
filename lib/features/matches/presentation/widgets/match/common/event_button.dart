import 'package:flutter/material.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';

class EventButton extends StatelessWidget {
  const EventButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

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
          padding: const EdgeInsets.all(16.0),
          child: Text(text, style: theme.textTheme.labelSmall),
        ),
      ),
    );
  }
}
