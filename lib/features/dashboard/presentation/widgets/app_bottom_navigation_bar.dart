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
          top: Radius.circular(theme.navBarBorderRadius),
        ),
        boxShadow: theme.bottomNavigationBarBoxShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(theme.navBarBorderRadius),
        ),
        child: NavigationBar(
          height: theme.navBarHeight,
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
              theme.navBarBorderRadius,
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
    return NavigationDestination(
      label: label,
      icon: SizedBox(
        width: theme.navBarItemWidth,
        height: theme.navBarItemHeight,
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
        width: theme.navBarItemWidth,
        height: theme.navBarItemHeight,
        decoration: BoxDecoration(
          color: activeBgColor,
          borderRadius: BorderRadius.circular(
            theme.navBarBorderRadius,
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
