import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';

class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: theme.screenPadding,
        right: theme.screenPadding,
        top: theme.screenPadding,
      ),
      child: child,
    );
  }
}
