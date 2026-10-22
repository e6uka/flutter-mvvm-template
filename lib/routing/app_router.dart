import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_mvvm_template/routing/app_routes.dart';
import 'package:flutter_mvvm_template/views/activity_view.dart';
import 'package:flutter_mvvm_template/store/auth_state_provider.dart';
import 'package:flutter_mvvm_template/views/home_shell.dart';
import 'package:flutter_mvvm_template/views/home_view.dart';
import 'package:flutter_mvvm_template/views/login_view.dart';
import 'package:flutter_mvvm_template/views/profile_view.dart';
import 'package:flutter_mvvm_template/views/splash_view.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(
    authStateProvider.select(
      (s) => (
        isInitializing: s.isInitializing,
        isAuthenticated: s.isAuthenticated,
      ),
    ),
  );

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final onSplash = location == AppRoutes.splash;
      final onLogin = location == AppRoutes.login;

      if (auth.isInitializing) return onSplash ? null : AppRoutes.splash;
      if (!auth.isAuthenticated) return onLogin ? null : AppRoutes.login;
      if (onSplash || onLogin) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => _fadePage(const SplashView()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _fadePage(const LoginView()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          _branch(AppRoutes.home, const HomeView()),
          _branch(AppRoutes.activity, const ActivityView()),
          _branch(AppRoutes.profile, const ProfileView()),
        ],
      ),
    ],
  );
});

StatefulShellBranch _branch(String path, Widget view) => StatefulShellBranch(
  routes: [
    GoRoute(
      path: path,
      pageBuilder: (context, state) => NoTransitionPage(child: view),
    ),
  ],
);

CustomTransitionPage<void> _fadePage(Widget child) => CustomTransitionPage(
  child: child,
  transitionDuration: const Duration(milliseconds: 350),
  transitionsBuilder: (context, animation, secondary, child) =>
      FadeTransition(opacity: animation, child: child),
);
