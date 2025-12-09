import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/cache_service.dart';
import '../services/supabase_service.dart';
import '../repositories/prompt_repository.dart';

/// Provider for CacheService
final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService();
});

/// Provider for SupabaseService
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Provider for PromptRepository
final promptRepositoryProvider = Provider<PromptRepository>((ref) {
  return PromptRepository(
    supabaseService: ref.watch(supabaseServiceProvider),
    cacheService: ref.watch(cacheServiceProvider),
  );
});
