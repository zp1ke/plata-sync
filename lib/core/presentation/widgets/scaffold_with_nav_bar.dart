import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plata_sync/core/presentation/resources/app_icons.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(AppIcons.homeOutlined),
            selectedIcon: Icon(AppIcons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.accountsOutlined),
            selectedIcon: Icon(AppIcons.accounts),
            label: 'Accounts',
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
