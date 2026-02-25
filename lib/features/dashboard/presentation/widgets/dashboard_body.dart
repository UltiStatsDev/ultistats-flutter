import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key, required this.child});

  final Widget child;

  void navigateTo(TabsRouter router, int index) {
    router.setActiveIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context);

    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                navigateTo(tabsRouter, 0);
              },
              child: Text("Игроки"),
            ),
            ElevatedButton(
              onPressed: () {
                navigateTo(tabsRouter, 1);
              },
              child: Text("Матчи"),
            ),
            ElevatedButton(
              onPressed: () {
                navigateTo(tabsRouter, 2);
              },
              child: Text("Команды"),
            ),
          ],
        ),
        Expanded(
          child: child,
        )
      ],
    );
  }
}
