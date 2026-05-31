import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hakeem/features/auth/presentation/screens/login_screen.dart';
import 'package:hakeem/features/auth/presentation/screens/signup_screen.dart';
import 'package:hakeem/features/home/presentation/screens/home_screen.dart';
import 'package:hakeem/features/splash/presentation/screens/splash_screen.dart';
import 'package:hakeem/features/main_layout/presentation/screens/main_layout_screen.dart';
import 'package:hakeem/features/patient_dashboard/presentation/screens/dashboard_screen.dart';
import 'package:hakeem/features/settings/presentation/screens/settings_screen.dart';
import 'package:hakeem/features/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import 'package:hakeem/features/smart_health/presentation/screens/smart_health_screen.dart';
import 'package:hakeem/features/assistant/presentation/screens/ai_chat_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/assistant',
      builder: (context, state) => const AiChatScreen(),
    ),
    
    // Main Layout with Bottom Navigation Bar & Swipeable PageView
    ShellRoute(
      builder: (context, state, child) {
        return MainLayoutScreen(state: state, child: child);
      },
      routes: [
        // Tab 0: Dashboard
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        // Tab 1: AI Assistant (Hakeem)
        GoRoute(
          path: '/appointments',
          builder: (context, state) => const AiAssistantScreen(),
        ),
        // Tab 2: Home (Center)
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        // Tab 3: Smart Health Hub
        GoRoute(
          path: '/records',
          builder: (context, state) => const SmartHealthScreen(),
        ),
        // Tab 4: Settings
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
