import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/prompt_provider.dart';
import '../../core/providers.dart';

/// Admin screen for managing prompts
class AdminPromptListScreen extends ConsumerWidget {
  const AdminPromptListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promptsAsync = ref.watch(promptsStreamProvider);
    final supabaseService = ref.watch(supabaseServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabaseService.signOut();
              if (context.mounted) {
                context.go('/home');
              }
            },
          ),
        ],
      ),
      body: promptsAsync.when(
        data: (prompts) {
          if (prompts.isEmpty) {
            return const Center(
              child: Text('No prompts yet. Create your first prompt!'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: prompts.length,
            itemBuilder: (context, index) {
              final prompt = prompts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: prompt.imageUrl != null
                      ? Image.network(
                          prompt.imageUrl!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image),
                        ),
                  title: Text(
                    prompt.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    prompt.modelProvider != null
                        ? '${prompt.modelProvider!.displayName} – ${prompt.modelName ?? ""}'
                        : 'No model info',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit button
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.push('/admin/prompt/edit/${prompt.id}', extra: prompt);
                        },
                      ),
                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteDialog(context, ref, prompt.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error loading prompts: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/admin/prompt/new');
        },
        icon: const Icon(Icons.add),
        label: const Text('New Prompt'),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref, String promptId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Prompt'),
        content: const Text('Are you sure you want to delete this prompt? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final repository = ref.read(promptRepositoryProvider);
        
        // Get prompts from the stream to find the one to delete
        final promptsAsync = ref.read(promptsStreamProvider);
        final prompts = promptsAsync.value;
        
        if (prompts == null) {
          throw Exception('Unable to load prompts');
        }
        
        // Safely find the prompt
        final prompt = prompts.where((p) => p.id == promptId).firstOrNull;
        
        if (prompt == null) {
          throw Exception('Prompt not found');
        }
        
        await repository.deletePrompt(prompt);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prompt deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting prompt: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
