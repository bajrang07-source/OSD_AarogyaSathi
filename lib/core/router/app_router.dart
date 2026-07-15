import 'package:go_router/go_router.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/symptom_checker/screens/symptom_checker_screen.dart';
import '../../features/first_aid/screens/first_aid_screen.dart';
import '../../features/hospitals/screens/hospitals_screen.dart';
import '../../features/health_card/screens/health_card_screen.dart';
import '../../features/transport/screens/transport_screen.dart';
import '../constants/app_routes.dart';
import '../../main_shell.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.symptomChecker,
                name: 'symptomChecker',
                builder: (context, state) => const SymptomCheckerScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.firstAid,
                name: 'firstAid',
                builder: (context, state) => const FirstAidScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.hospitals,
                name: 'hospitals',
                builder: (context, state) => const HospitalsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transport,
                name: 'transport',
                builder: (context, state) => const TransportScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.healthCard,
                name: 'healthCard',
                builder: (context, state) => const HealthCardScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
