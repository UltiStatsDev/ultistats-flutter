import 'package:flutter/material.dart';

class AppRefreshingIndicator extends StatelessWidget {
  const AppRefreshingIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final RefreshCallback onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: theme.primaryColor,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: child,
    );
  }
}
