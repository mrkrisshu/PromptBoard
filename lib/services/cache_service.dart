import 'package:hive_flutter/hive_flutter.dart';
import '../models/prompt_model.dart';

/// Service for local caching using Hive
class CacheService {
  static const String _promptsBoxName = 'prompts_cache';
  static const String _tagsBoxName = 'tags_cache';
  static const String _metadataBoxName = 'metadata';

  late Box<dynamic> _promptsBox;
  late Box<dynamic> _tagsBox;
  late Box<dynamic> _metadataBox;

  /// Initialize Hive and open boxes
  Future<void> initialize() async {
    await Hive.initFlutter();
    _promptsBox = await Hive.openBox(_promptsBoxName);
    _tagsBox = await Hive.openBox(_tagsBoxName);
    _metadataBox = await Hive.openBox(_metadataBoxName);
  }

  /// Save prompts to cache
  Future<void> savePrompts(List<PromptModel> prompts) async {
    final promptsJson = prompts.map((p) => p.toJson()).toList();
    await _promptsBox.put('prompts', promptsJson);
    await _metadataBox.put('lastSyncTimestamp', DateTime.now().millisecondsSinceEpoch);
  }

  /// Get cached prompts
  List<PromptModel>? getCachedPrompts() {
    final promptsJson = _promptsBox.get('prompts') as List<dynamic>?;
    if (promptsJson == null) return null;

    return promptsJson
        .map((json) => PromptModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  /// Save tags to cache
  Future<void> saveTags(List<String> tags) async {
    await _tagsBox.put('tags', tags);
  }

  /// Get cached tags
  List<String> getCachedTags() {
    final tags = _tagsBox.get('tags') as List<dynamic>?;
    return tags?.cast<String>() ?? [];
  }

  /// Get last sync timestamp
  DateTime? getLastSyncTime() {
    final timestamp = _metadataBox.get('lastSyncTimestamp') as int?;
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  /// Check if cache exists
  bool hasCachedData() {
    return _promptsBox.get('prompts') != null;
  }

  /// Clear all cache
  Future<void> clearCache() async {
    await _promptsBox.clear();
    await _tagsBox.clear();
    await _metadataBox.clear();
  }
}
