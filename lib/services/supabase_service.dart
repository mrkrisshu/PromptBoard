import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/prompt_model.dart';

/// Service for all Supabase operations
class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Storage bucket name
  static const String _bucketName = 'prompt-images';

  /// Get all prompts
  Future<List<PromptModel>> getPrompts() async {
    final response = await _client
        .from('prompts')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => PromptModel.fromJson(json))
        .toList();
  }

  /// Get prompts stream for real-time updates
  Stream<List<PromptModel>> getPromptsStream() {
    return _client
        .from('prompts')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => PromptModel.fromJson(json)).toList());
  }

  /// Search prompts by title or text
  Future<List<PromptModel>> searchPrompts(String query) async {
    final response = await _client
        .from('prompts')
        .select()
        .or('title.ilike.%$query%,prompt_text.ilike.%$query%')
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => PromptModel.fromJson(json))
        .toList();
  }

  /// Filter prompts by tags
  Future<List<PromptModel>> filterByTags(List<String> tags) async {
    final response = await _client
        .from('prompts')
        .select()
        .contains('tags', tags)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => PromptModel.fromJson(json))
        .toList();
  }

  /// Get all unique tags
  Future<List<String>> getAllTags() async {
    final response = await _client
        .from('prompts')
        .select('tags')
        .not('tags', 'is', null);

    final allTags = <String>{};
    for (final row in response as List) {
      if (row['tags'] != null) {
        allTags.addAll(List<String>.from(row['tags']));
      }
    }

    return allTags.toList()..sort();
  }

  /// Upload image to Supabase Storage
  Future<String> uploadImage(File imageFile, String promptId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
    final filePath = '$promptId/$fileName';

    await _client.storage
        .from(_bucketName)
        .upload(filePath, imageFile);

    final imageUrl = _client.storage
        .from(_bucketName)
        .getPublicUrl(filePath);

    return imageUrl;
  }

  /// Delete image from Supabase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      // Extract file path from URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf(_bucketName);
      if (bucketIndex != -1) {
        final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
        await _client.storage.from(_bucketName).remove([filePath]);
      }
    } catch (e) {
      print('Failed to delete image: $e');
    }
  }

  /// Call link-preview Edge Function to convert URLs to direct image URLs
  Future<String?> callLinkPreview(String url) async {
    try {
      final response = await _client.functions.invoke(
        'rapid-responder',  // Using your deployed function name
        body: {
          'url': url,
          // Instagram credentials
          'ig_app_id': '2918019791890576',
          'ig_app_secret': '1e7c49ae313be4c8f9fd80bc23383d32',
        },
      );

      if (response.data != null && response.data is Map) {
        final imageUrl = response.data['image_url'];
        if (imageUrl != null && imageUrl.toString().isNotEmpty) {
          return imageUrl.toString();
        }
      }
    } catch (e) {
      print('Link preview error: $e');
    }
    
    return null;
  }

  /// Create new prompt
  Future<String> createPrompt(PromptModel prompt) async {
    // Convert to JSON and remove the id field (Supabase will auto-generate it)
    final json = prompt.toJson();
    json.remove('id');  // Don't send empty id, let Supabase generate it
    
    final response = await _client
        .from('prompts')
        .insert(json)
        .select()
        .single();

    return response['id'];
  }

  /// Update existing prompt
  Future<void> updatePrompt(PromptModel prompt) async {
    await _client
        .from('prompts')
        .update(prompt.toJson())
        .eq('id', prompt.id);
  }

  /// Delete prompt
  Future<void> deletePrompt(String promptId) async {
    await _client
        .from('prompts')
        .delete()
        .eq('id', promptId);
  }

  /// Sign in with email and password (for admin)
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Get current user
  User? get currentUser => _client.auth.currentUser;

  /// Check if user is admin
  bool isAdmin() {
    final user = currentUser;
    if (user == null) return false;
    // Check if email matches admin email
    return user.email == 'admin@promptboard.com';
  }

  /// Auth state changes stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
