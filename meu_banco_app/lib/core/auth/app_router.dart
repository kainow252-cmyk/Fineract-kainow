import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/transfer/screens/transfer_screen.dart';
import '../../features/extract/screens/extract_screen.dart';
import '../../features/charge/screens/charge_screen.dart';
import '../../features/cards/screens/cards_screen.dart';
import '../../features/loans/screens/loans_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../shared/widgets/main_scaffold.dart';

// ─── Rotas ────────────────────────────────────────────────────────────
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const transfer = '/transfer';
  static const extract = '/extract';
  static const charge = '/charge';
  static const cards = '/cards';
  static const loans = '/loans';
  static const profile = '/profile';
}

// ─── Router Provider ──────────────────────────────────────────────────
final routerProvider = Provider<GoRouter>((ref) {
  // Observa o AsyncValue<AuthState>
  final authAsync = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isSplash = state.matchedLocation == AppRoutes.splash;

      if (isSplash) return null; // Sempre mostra splash primeiro

      // Enquanto carrega, não redireciona
      final auth = authAsync.value;
      if (auth == null) return null;

      if (auth.status == AuthStatus.unauthenticated && !isLoggingIn) {
        return AppRoutes.login;
      }

      if (auth.status == AuthStatus.authenticated && isLoggingIn) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.transfer,
            builder: (_, __) => const TransferScreen(),
          ),
          GoRoute(
            path: AppRoutes.extract,
            builder: (_, __) => const ExtractScreen(),
          ),
          GoRoute(
            path: AppRoutes.charge,
            builder: (_, __) => const ChargeScreen(),
          ),
          GoRoute(
            path: AppRoutes.cards,
            builder: (_, __) => const CardsScreen(),
          ),
          GoRoute(
            path: AppRoutes.loans,
            builder: (_, __) => const LoansScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
