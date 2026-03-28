import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabsRouter = AutoTabsRouter.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(theme.bottomNavigationBarBorderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(theme.bottomNavigationBarBorderRadius),
        ),
        child: NavigationBar(
          height: theme.bottomNavigationBarHeight,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: (index) {
            tabsRouter.setActiveIndex(index);
          },
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          indicatorColor: Colors.transparent,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              theme.bottomNavigationBarBorderRadius,
            ),
          ),

          destinations: [
            _NavigationBarDestination(
              activeIndex: tabsRouter.activeIndex,
              index: 0,
              icon: Icons.scoreboard_outlined,
              label: "Матчи",
            ),
            _NavigationBarDestination(
              activeIndex: tabsRouter.activeIndex,
              index: 1,
              icon: Icons.group_outlined,
              label: "Команды",
            ),
            _NavigationBarDestination(
              activeIndex: tabsRouter.activeIndex,
              index: 2,
              icon: Icons.person_outlined,
              label: "Игроки",
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationBarDestination extends StatelessWidget {
  const _NavigationBarDestination({
    required this.index,
    required this.activeIndex,
    required this.label,
    required this.icon,
  });

  final int index;
  final int activeIndex;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeBgColor = theme.primaryColor;
    final width = 90.0;
    final height = 54.0;
    return NavigationDestination(
      label: label,
      icon: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: theme.bottomNavigationBarTheme.unselectedIconTheme?.color,
              size: theme.bottomNavigationBarTheme.unselectedIconTheme?.size,
            ),
            Text(
              label,
              style: theme.bottomNavigationBarTheme.unselectedLabelStyle,
            ),
          ],
        ),
      ),
      selectedIcon: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: activeBgColor,
          borderRadius: BorderRadius.circular(
            theme.bottomNavigationBarBorderRadius,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: theme.bottomNavigationBarTheme.selectedIconTheme?.color,
              size: theme.bottomNavigationBarTheme.selectedIconTheme?.size,
            ),
            Text(
              label,
              style: theme.bottomNavigationBarTheme.selectedLabelStyle,
            ),
          ],
        ),
      ),
    );
  }
}
