import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/prompt_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/tag_chip.dart';
import '../widgets/prompt_card.dart';
import '../models/prompt_model.dart';

/// Home screen displaying prompt feed with search and filters
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredPrompts = ref.watch(filteredPromptsProvider);
    final selectedModel = ref.watch(selectedModelProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100], // Grey background for the whole page
      appBar: AppBar(
        title: const Text('PromptBoard'),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        actions: [
          // Admin menu
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'admin_login') {
                context.push('/admin/login');
              } else if (value == 'admin_panel') {
                context.push('/admin/prompts');
              }
            },
            itemBuilder: (context) => [
              if (isAdmin)
                const PopupMenuItem(
                  value: 'admin_panel',
                  child: Text('Admin Panel'),
                )
              else
                const PopupMenuItem(
                  value: 'admin_login',
                  child: Text('Admin Login'),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh prompts
          ref.invalidate(promptsStreamProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SearchBarWidget(
                  hintText: 'Search tags or text',
                  onChanged: (query) {
                    ref.read(searchQueryProvider.notifier).updateQuery(query);
                  },
                  onClear: searchQuery.isNotEmpty
                      ? () {
                          ref.read(searchQueryProvider.notifier).clearQuery();
                        }
                      : null,
                ),
              ),
            ),

            // Model filter chips (ChatGPT, Claude, Gemini)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // All filter
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TagChip(
                        label: 'All',
                        isSelected: selectedModel == null,
                        onTap: () {
                          ref.read(selectedModelProvider.notifier).state = null;
                        },
                      ),
                    ),
                    // ChatGPT filter
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TagChip(
                        label: 'ChatGPT',
                        isSelected: selectedModel == ModelProvider.chatgpt,
                        onTap: () {
                          ref.read(selectedModelProvider.notifier).state = ModelProvider.chatgpt;
                        },
                      ),
                    ),
                    // Claude filter
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TagChip(
                        label: 'Claude',
                        isSelected: selectedModel == ModelProvider.claude,
                        onTap: () {
                          ref.read(selectedModelProvider.notifier).state = ModelProvider.claude;
                        },
                      ),
                    ),
                    // Gemini filter
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TagChip(
                        label: 'Gemini',
                        isSelected: selectedModel == ModelProvider.gemini,
                        onTap: () {
                          ref.read(selectedModelProvider.notifier).state = ModelProvider.gemini;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Prompts grid
            filteredPrompts.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Text(
                        searchQuery.isNotEmpty || selectedModel != null
                            ? 'No prompts found'
                            : 'Loading prompts...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.52,crossAxisSpacing: 12,mainAxisSpacing: 12,),delegate: SliverChildBuilderDelegate((context, index) {return PromptCard(prompt: filteredPrompts[index]);},childCount: filteredPrompts.length,),),
                  ),
          ],
        ),
      ),
    );
  }
}
