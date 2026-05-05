{{#is_bloc}}import 'dart:async';

{{/is_bloc}}
import 'package:flutter/material.dart';
{{#is_riverpod}}
import 'package:flutter_riverpod/flutter_riverpod.dart';
{{/is_riverpod}}
import 'package:go_router/go_router.dart';

import '../core/router/app_shell.dart';
import '../core/router/route_paths.dart';
{{#is_riverpod}}
import '../features/auth/presentation/providers/auth_controller.dart';
{{/is_riverpod}}{{#is_bloc}}import '../features/auth/presentation/controllers/auth_bloc.dart';
{{/is_bloc}}
import '../features/auth/presentation/views/sign_in_view.dart';
import '../features/home/presentation/views/home_view.dart';
import '../features/settings/presentation/views/settings_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

{{#is_riverpod}}
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.home,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      if (authState.isLoading && !authState.hasValue) {
        return null;
      }

      final isSignedIn = authState.valueOrNull != null;
      final isSigningIn = state.matchedLocation == RoutePaths.signIn;

      if (!isSignedIn && !isSigningIn) {
        return RoutePaths.signIn;
      }

      if (isSignedIn && isSigningIn) {
        return RoutePaths.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.signIn,
        name: RouteNames.signIn,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SignInView(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: RoutePaths.home,
            name: RouteNames.home,
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            path: RoutePaths.settings,
            name: RouteNames.settings,
            builder: (context, state) => const SettingsView(),
          ),
        ],
      ),
    ],
  );
});

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this._ref) {
    _subscription = _ref.listen<AsyncValue<Object?>>(
      authControllerProvider,
      (previous, next) => notifyListeners(),
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AsyncValue<Object?>> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
{{/is_riverpod}}{{#is_bloc}}
GoRouter createAppRouter(AuthBloc authBloc) {
  final refreshNotifier = GoRouterBlocRefreshNotifier(authBloc);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.home,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = authBloc.state;

      if (authState is AuthInitial || authState is AuthLoading) {
        return null;
      }

      final isSignedIn = authState is AuthAuthenticated;
      final isSigningIn = state.matchedLocation == RoutePaths.signIn;

      if (!isSignedIn && !isSigningIn) {
        return RoutePaths.signIn;
      }

      if (isSignedIn && isSigningIn) {
        return RoutePaths.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.signIn,
        name: RouteNames.signIn,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SignInView(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: RoutePaths.home,
            name: RouteNames.home,
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            path: RoutePaths.settings,
            name: RouteNames.settings,
            builder: (context, state) => const SettingsView(),
          ),
        ],
      ),
    ],
  );
}

class GoRouterBlocRefreshNotifier extends ChangeNotifier {
  GoRouterBlocRefreshNotifier(AuthBloc authBloc) {
    _subscription = authBloc.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
{{/is_bloc}}
