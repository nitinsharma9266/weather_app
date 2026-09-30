import 'package:flutter/material.dart';

import 'home_screen.dart';
import '../forecast/forecast_screen.dart';
import '../search/search_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  late int _selectedIndex;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex;

    _screens = [
      HomeScreen(
        onNavigate: _onNavigationTap,
      ),
      const ForecastScreen(),
      const SearchScreen(),
    ];
  }

  void _onNavigationTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final Color accentColor = isDark
        ? const Color(0xFF58B9FF)
        : const Color(0xFF1594E8);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF071522).withValues(
            alpha: 0.96,
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(
                alpha: 0.08,
              ),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            height: 76,
            backgroundColor: Colors.transparent,
            elevation: 0,

            selectedIndex: _selectedIndex,

            onDestinationSelected: _onNavigationTap,

            indicatorColor: accentColor.withValues(
              alpha: 0.18,
            ),

            labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,

            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.home_outlined,
                  color: Colors.white60,
                ),
                selectedIcon: Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                ),
                label: 'Home',
              ),

              NavigationDestination(
                icon: Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.white60,
                ),
                selectedIcon: Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                ),
                label: 'Forecast',
              ),

              NavigationDestination(
                icon: Icon(
                  Icons.search_outlined,
                  color: Colors.white60,
                ),
                selectedIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
                label: 'Search',
              ),
            ],
          ),
        ),
      ),
    );
  }
}