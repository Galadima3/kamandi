import 'package:go_router/go_router.dart';
import 'package:kamandi/app.dart';
import 'package:kamandi/src/features/auth/presentation/screens/landing_screen.dart';
import 'package:kamandi/src/features/auth/presentation/screens/login_screen.dart';
import 'package:kamandi/src/features/auth/presentation/screens/register_screen.dart';
import 'package:kamandi/src/features/auth/presentation/screens/splash_screen.dart';
import 'package:kamandi/src/features/gallery/home_screen.dart';
import 'package:kamandi/src/routing/route_paths.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    name: RoutePaths.splashScreenRoute,
    path: '/',
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    name: RoutePaths.homeScreenRoute,
    path: '/${RoutePaths.homeScreenRoute}',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    name: RoutePaths.loginScreenRoute,
    path: '/${RoutePaths.loginScreenRoute}',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    name: RoutePaths.registerScreenRoute,
    path: '/${RoutePaths.registerScreenRoute}',
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
    name: RoutePaths.landingScreenRoute,
    path: '/${RoutePaths.landingScreenRoute}',
    builder: (context, state) => const LandingScreen(),
  ),

  GoRoute(
    name: RoutePaths.appScreenRoute,
    path: '/${RoutePaths.appScreenRoute}',
    builder: (context, state) => const App(),
  ),
]);
