import 'package:go_router/go_router.dart';
import 'package:plata_sync/core/presentation/widgets/scaffold_with_nav_bar.dart';
import 'package:plata_sync/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:plata_sync/features/home/presentation/screens/home_screen.dart';

class AppRoutes {
  static const home = '/';
  static const accounts = '/accounts';
}

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
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
        ],
      ),
    ],
  );
}
