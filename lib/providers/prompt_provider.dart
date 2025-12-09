import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prompt_model.dart';
import '../core/providers.dart';

/// Provider for prompts stream
final promptsStreamProvider = StreamProvider<List<PromptModel>>((ref) {
  final repository = ref.watch(promptRepositoryProvider);
  return repository.getPromptsStream();
});

/// Provider for prompts list (async, cache-first)
final promptsProvider = FutureProvider<List<PromptModel>>((ref) async {
  final repository = ref.watch(promptRepositoryProvider);
  return repository.getPrompts();
});

/// Provider for all tags
final tagsProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(promptRepositoryProvider);
  return repository.getAllTags();
});

/// State notifier for search query
class SearchQueryNotifier extends StateNotifier<String> {
  SearchQueryNotifier() : super('');

  void updateQuery(String query) {
    state = query;
  }

  void clearQuery() {
    state = '';
  }
}

final searchQueryProvider = StateNotifierProvider<SearchQueryNotifier, String>((ref) {
  return SearchQueryNotifier();
});

/// Provider for selected model filter (ChatGPT, Claude, Gemini)
final selectedModelProvider = StateProvider<ModelProvider?>((ref) => null);

/// State notifier for selected tags filter (kept for compatibility)
class SelectedTagsNotifier extends StateNotifier<List<String>> {
  SelectedTagsNotifier() : super(['All']);

  void toggleTag(String tag) {
    if (tag == 'All') {
      state = ['All'];
    } else {
      final newState = state.where((t) => t != 'All').toList();
      if (newState.contains(tag)) {
        newState.remove(tag);
      } else {
        newState.add(tag);
      }
      state = newState.isEmpty ? ['All'] : newState;
    }
  }

  void clearFilters() {
    state = ['All'];
  }
}

final selectedTagsProvider = StateNotifierProvider<SelectedTagsNotifier, List<String>>((ref) {
  return SelectedTagsNotifier();
});

/// Provider for filtered prompts based on search and model filters
final filteredPromptsProvider = Provider<List<PromptModel>>((ref) {
  final promptsAsync = ref.watch(promptsStreamProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedModel = ref.watch(selectedModelProvider);

  return promptsAsync.when(
    data: (prompts) {
      var filtered = prompts;

      // Apply search filter
      if (searchQuery.isNotEmpty) {
        filtered = filtered.where((p) {
          final matchTitle = p.title.toLowerCase().contains(searchQuery.toLowerCase());
          final matchText = p.promptText.toLowerCase().contains(searchQuery.toLowerCase());
          final matchTags = p.tags.any((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()));
          return matchTitle || matchText || matchTags;
        }).toList();
      }

      // Apply model filter
      if (selectedModel != null) {
        filtered = filtered.where((p) {
          return p.modelProvider == selectedModel;
        }).toList();
      }

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
