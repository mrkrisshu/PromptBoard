import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/prompt_detail_screen.dart';
import '../screens/admin/admin_login_screen.dart';
import '../screens/admin/admin_prompt_list_screen.dart';
import '../screens/admin/prompt_editor_screen.dart';
import '../models/prompt_model.dart';

/// App routing configuration using GoRouter
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/prompt/:id',
      builder: (context, state) {
        final prompt = state.extra as PromptModel;
        return PromptDetailScreen(prompt: prompt);
      },
    ),
    GoRoute(
      path: '/admin/login',
      builder: (context, state) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: '/admin/prompts',
      builder: (context, state) => const AdminPromptListScreen(),
    ),
    GoRoute(
      path: '/admin/prompt/new',
      builder: (context, state) => const PromptEditorScreen(),
    ),
    GoRoute(
      path: '/admin/prompt/edit/:id',
      builder: (context, state) {
        final prompt = state.extra as PromptModel;
        return PromptEditorScreen(existingPrompt: prompt);
      },
    ),
  ],
);
