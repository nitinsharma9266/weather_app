import 'package:flutter/material.dart';

import '../../app/routes.dart';

class AppBottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
  });

  void _onDestinationSelected(
      BuildContext context,
      int index,
      ) {
    if (index == selectedIndex) {
      return;
    }

    switch (index) {
      case 0:
        Navigator.pushNamed(
          context,
          AppRoutes.home,
        );
        break;

      case 1:
        Navigator.pushNamed(
          context,
          AppRoutes.forecast,
        );
        break;

      case 2:
        Navigator.pushNamed(
          context,
          AppRoutes.search,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final Color backgroundColor = isDark
        ? const Color(0xFF0B1726)
        : Colors.white;

    final Color selectedColor = isDark
        ? const Color(0xFF55B9FF)
        : Theme.of(context).colorScheme.primary;

    final Color unselectedColor = isDark
        ? Colors.white54
        : Colors.black45;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        12,
        0,
        12,
        12,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.28 : 0.10,
            ),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            _onDestinationSelected(
              context,
              index,
            );
          },
          backgroundColor: backgroundColor,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          height: 72,
          indicatorColor: selectedColor.withValues(
            alpha: 0.14,
          ),
          labelBehavior:
          NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: unselectedColor,
              ),
              selectedIcon: Icon(
                Icons.home_rounded,
                color: selectedColor,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.calendar_month_outlined,
                color: unselectedColor,
              ),
              selectedIcon: Icon(
                Icons.calendar_month_rounded,
                color: selectedColor,
              ),
              label: 'Forecast',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.search_outlined,
                color: unselectedColor,
              ),
              selectedIcon: Icon(
                Icons.search_rounded,
                color: selectedColor,
              ),
              label: 'Search',
            ),
          ],
        ),
      ),
    );
  }
}