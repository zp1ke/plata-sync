import 'package:go_router/go_router.dart';
import 'package:plata_sync/core/ui/widgets/scaffold_with_nav_bar.dart';
import 'package:plata_sync/features/accounts/ui/screens/accounts_screen.dart';
import 'package:plata_sync/features/categories/ui/screens/categories_screen.dart';
import 'package:plata_sync/features/settings/ui/screens/settings_screen.dart';
import 'package:plata_sync/features/transactions/ui/screens/transactions_screen.dart';

class AppRoutes {
  static const transactions = '/';
  static const accounts = '/accounts';
  static const categories = '/categories';
  static const settings = '/settings';
}

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.transactions,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                builder: (context, state) => const TransactionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.accounts,
                builder: (context, state) => const AccountsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.categories,
                builder: (context, state) => const CategoriesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
