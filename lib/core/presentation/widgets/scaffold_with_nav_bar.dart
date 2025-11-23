import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plata_sync/core/presentation/resources/app_icons.dart';
import 'package:plata_sync/l10n/app_localizations.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: [
          NavigationDestination(
            icon: const Icon(AppIcons.transactionsOutlined),
            selectedIcon: const Icon(AppIcons.transactions),
            label: l10n.navTransactions,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.accountsOutlined),
            selectedIcon: const Icon(AppIcons.accounts),
            label: l10n.navAccounts,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.categoriesOutlined),
            selectedIcon: const Icon(AppIcons.categories),
            label: l10n.navCategories,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.settingsOutlined),
            selectedIcon: const Icon(AppIcons.settings),
            label: l10n.navSettings,
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
