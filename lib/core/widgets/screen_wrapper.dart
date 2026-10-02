import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ultistats/core/themes/app_themes.dart';

class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Padding(
        padding: EdgeInsets.only(
          left: theme.screenPadding,
          right: theme.screenPadding,
          top: mediaQuery.padding.top,
          bottom: mediaQuery.padding.bottom,
        ),
        child: child,
      ),
    );
  }
}
