import 'package:flutter/material.dart';

class NoTeamsWidget extends StatelessWidget {
  const NoTeamsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text("Нет команд", style: theme.textTheme.headlineMedium),
    );
  }
}
