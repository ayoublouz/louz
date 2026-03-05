import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/checkin/presentation/checkin_screen.dart';
import '../../features/checkin/presentation/checkin_history_screen.dart';
import '../../features/dashboard/presentation/home_shell.dart';
import '../../features/friends/presentation/friends_screen.dart';
import '../../features/gallery/presentation/gallery_screen.dart';
import '../../features/interests/presentation/interests_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/todo/presentation/todo_screen.dart';
import '../../shared/services/firebase_providers.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final loggedIn = auth.value != null;
      final atAuth = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
      if (!loggedIn && !atAuth) return '/login';
      if (loggedIn && atAuth) return '/onboarding';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (c, s) => const SignupScreen()),
      GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
      GoRoute(path: '/', builder: (c, s) => const HomeShell()),
      GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
      GoRoute(path: '/interests', builder: (c, s) => const InterestsScreen()),
      GoRoute(path: '/checkin', builder: (c, s) => const CheckinScreen()),
      GoRoute(path: '/checkin-history', builder: (c, s) => const CheckinHistoryScreen()),
      GoRoute(path: '/friends', builder: (c, s) => const FriendsScreen()),
      GoRoute(path: '/gallery', builder: (c, s) => const GalleryScreen()),
      GoRoute(path: '/todos', builder: (c, s) => const TodoScreen()),
    ],
  );
});
