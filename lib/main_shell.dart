import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_strings.dart';

/// The persistent bottom-navigation shell that wraps all 5 tab branches.
/// Uses Material 3 NavigationBar with smooth indicator animations.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  static const List<_NavItem> _navItems = [
    _NavItem(
      label: AppStrings.navHome,
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _NavItem(
      label: AppStrings.navSymptomChecker,
      icon: Icons.health_and_safety_outlined,
      activeIcon: Icons.health_and_safety_rounded,
    ),
    _NavItem(
      label: AppStrings.navFirstAid,
      icon: Icons.local_hospital_outlined,
      activeIcon: Icons.local_hospital_rounded,
    ),
    _NavItem(
      label: AppStrings.navHospitals,
      icon: Icons.location_on_outlined,
      activeIcon: Icons.location_on_rounded,
    ),
    _NavItem(
      label: 'Transport',
      icon: Icons.directions_car_outlined,
      activeIcon: Icons.directions_car_rounded,
    ),
    _NavItem(
      label: AppStrings.navHealthCard,
      icon: Icons.badge_outlined,
      activeIcon: Icons.badge_rounded,
    ),
  ];

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      // Returning to the initial route when tapping the current tab
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _BottomNav(
        currentIndex: navigationShell.currentIndex,
        items: _navItems,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}

// ─── Internal bottom nav widget ───────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onDestinationSelected;

  const _BottomNav({
    required this.currentIndex,
    required this.items,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        animationDuration: const Duration(milliseconds: 400),
        destinations: items.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.activeIcon, color: cs.primary),
            label: item.label,
            tooltip: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
