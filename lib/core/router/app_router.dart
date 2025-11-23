import 'package:go_router/go_router.dart';
import 'package:plata_sync/features/home/presentation/screens/home_screen.dart';

class AppRoutes {
  static const home = '/';
}

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
