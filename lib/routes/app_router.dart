import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../providers/auth_provider.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String notifications = '/notifications';

  static GoRouter router(WidgetRef ref) {
    return GoRouter(
      initialLocation: AppRouter.splash,
      redirect: (context, state) {
        final authState = ref.watch(authNotifierProvider);
        final isLoggedIn = authState.isAuthenticated;

        // Check if we're on the splash or login route
        if (state.matchedLocation == AppRouter.splash ||
            state.matchedLocation == AppRouter.login) {
          // If already logged in, go to home
          if (isLoggedIn) {
            return AppRouter.home;
          }
          return null; // Let them stay on splash/login
        }

        // For all other routes, if not logged in, go to login
        if (!isLoggedIn && state.matchedLocation != AppRouter.login) {
          return AppRouter.login;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRouter.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRouter.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRouter.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRouter.notifications,
          builder: (context, state) => const NotificationScreen(),
        ),
      ],
    );
  }
}
