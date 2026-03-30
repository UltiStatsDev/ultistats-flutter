import 'package:flutter/material.dart';

class NoMatchesWidget extends StatelessWidget {
  const NoMatchesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        'Нет матчей',
        style: theme.textTheme.headlineMedium,
      ),
    );
  }
}
