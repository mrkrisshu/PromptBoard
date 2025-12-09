import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/providers.dart';

/// Provider for auth state changes
final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return supabaseService.authStateChanges;
});

/// Provider for current user
final currentUserProvider = Provider<User?>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return supabaseService.currentUser;
});

/// Provider to check if current user is admin
final isAdminProvider = Provider<bool>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return supabaseService.isAdmin();
});
