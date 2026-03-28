import 'package:flutter/material.dart';
import 'package:ultistats/features/dashboard/presentation/widgets/app_bottom_navigation_bar.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}
