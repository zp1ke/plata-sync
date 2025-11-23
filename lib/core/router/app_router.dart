import 'package:go_router/go_router.dart';
import 'package:plata_sync/core/presentation/widgets/scaffold_with_nav_bar.dart';
import 'package:plata_sync/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:plata_sync/features/categories/presentation/screens/categories_screen.dart';
import 'package:plata_sync/features/transactions/presentation/screens/transactions_screen.dart';

class AppRoutes {
  static const transactions = '/';
  static const accounts = '/accounts';
  static const categories = '/categories';
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
        ],
      ),
    ],
  );
}
