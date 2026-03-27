import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/dashboard/presentation/widgets/app_bottom_navigation_bar.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: theme.screenPadding,
          right: theme.screenPadding,
          top: theme.screenPadding,
        ),
        child: child,
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}
