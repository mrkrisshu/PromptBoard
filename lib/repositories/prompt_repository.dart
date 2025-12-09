import 'dart:io';
import '../models/prompt_model.dart';
import '../services/supabase_service.dart';
import '../services/cache_service.dart';

/// Repository for managing prompt data with Supabase
class PromptRepository {
  final SupabaseService _supabaseService;
  final CacheService _cacheService;

  PromptRepository({
    required SupabaseService supabaseService,
    required CacheService cacheService,
  })  : _supabaseService = supabaseService,
        _cacheService = cacheService;

  /// Get prompts from cache first, then sync from Supabase
  Future<List<PromptModel>> getPrompts() async {
    // Try to get from cache first
    final cachedPrompts = _cacheService.getCachedPrompts();
    if (cachedPrompts != null && cachedPrompts.isNotEmpty) {
      return cachedPrompts;
    }

    // No cache, fetch from Supabase
    final prompts = await _supabaseService.getPrompts();
    await _cacheService.savePrompts(prompts);

    // Extract and cache tags
    final tags = _extractTags(prompts);
    await _cacheService.saveTags(tags);

    return prompts;
  }

  /// Stream of prompts with automatic cache updates
  Stream<List<PromptModel>> getPromptsStream() {
    return _supabaseService.getPromptsStream().map((prompts) {
      // Update cache whenever new data arrives
      _cacheService.savePrompts(prompts);

      // Update tags cache
      final tags = _extractTags(prompts);
      _cacheService.saveTags(tags);

      return prompts;
    });
  }

  Future<List<PromptModel>> searchPrompts(String query) async {
    if (query.isEmpty) return await getPrompts();
    return await _supabaseService.searchPrompts(query);
  }

  /// Filter prompts by tags (client-side for now, could use Supabase)
  List<PromptModel> filterByTags(List<PromptModel> prompts, List<String> tags) {
    if (tags.isEmpty || tags.contains('All')) return prompts;

    return prompts.where((p) {
      return p.tags.any((tag) => tags.contains(tag));
    }).toList();
  }

  /// Get all unique tags
  Future<List<String>> getAllTags() async {
    // Try cache first
    final cachedTags = _cacheService.getCachedTags();
    if (cachedTags.isNotEmpty) {
      return cachedTags;
    }

    // Fetch from Supabase
    final tags = await _supabaseService.getAllTags();
    await _cacheService.saveTags(tags);
    return tags;
  }

  /// Create new prompt
  Future<String> createPrompt({
    required PromptModel prompt,
    File? imageFile,
  }) async {
    String? imageUrl = prompt.imageUrl;

    // Upload image if provided
    if (imageFile != null) {
      // Generate temporary ID for upload path
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      imageUrl = await _supabaseService.uploadImage(imageFile, tempId);
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      // If URL is provided, try to convert it to direct image URL
      // Useful for Instagram, Pinterest, etc.
      final directImageUrl = await _convertToDirectImageUrl(imageUrl);
      if (directImageUrl != null) {
        imageUrl = directImageUrl;
      }
      // If conversion fails, use original URL as fallback
    }

    // Create prompt with image URL
    final promptWithImage = prompt.copyWith(
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdByUserId: _supabaseService.currentUser?.id,
    );

    final promptId = await _supabaseService.createPrompt(promptWithImage);

    return promptId;
  }

  /// Convert Instagram/Pinterest/any URL to direct image URL
  Future<String?> _convertToDirectImageUrl(String url) async {
    try {
      // Only convert if it's likely a social media link or web page
      if (url.contains('instagram.com') || 
          url.contains('pinterest.com') || 
          url.contains('pin.it') ||
          (!url.endsWith('.jpg') && !url.endsWith('.png') && !url.endsWith('.webp'))) {
        
        final response = await _supabaseService.callLinkPreview(url);
        return response;
      }
    } catch (e) {
      print('Link preview conversion failed: $e');
    }
    
    return null; // Return null to use original URL
  }

  /// Update existing prompt
  Future<void> updatePrompt({
    required PromptModel prompt,
    File? newImageFile,
  }) async {
    String? imageUrl = prompt.imageUrl;

    // If new image provided, upload it
    if (newImageFile != null) {
      // Delete old image if it's from Supabase Storage
      if (prompt.imageUrl != null && prompt.imageUrl!.contains('supabase')) {
        await _supabaseService.deleteImage(prompt.imageUrl!);
      }

      // Upload new image
      imageUrl = await _supabaseService.uploadImage(newImageFile, prompt.id);
    }

    // Update prompt
    final updatedPrompt = prompt.copyWith(
      imageUrl: imageUrl,
      updatedAt: DateTime.now(),
    );

    await _supabaseService.updatePrompt(updatedPrompt);
  }

  /// Delete prompt
  Future<void> deletePrompt(PromptModel prompt) async {
    // Delete image from storage if it's from Supabase
    if (prompt.imageUrl != null && prompt.imageUrl!.contains('supabase')) {
      await _supabaseService.deleteImage(prompt.imageUrl!);
    }

    // Delete from database
    await _supabaseService.deletePrompt(prompt.id);
  }

  /// Extract unique tags from prompts
  List<String> _extractTags(List<PromptModel> prompts) {
    final tags = <String>{};
    for (final prompt in prompts) {
      tags.addAll(prompt.tags);
    }
    return tags.toList()..sort();
  }
}
