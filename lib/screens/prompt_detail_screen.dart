import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/prompt_model.dart';
import '../widgets/tag_chip.dart';

/// Detail screen showing full prompt information
class PromptDetailScreen extends StatelessWidget {
  final PromptModel prompt;

  const PromptDetailScreen({
    super.key,
    required this.prompt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: prompt.imageUrl != null
                  ? Hero(
                      tag: 'prompt_image_${prompt.id}',
                      child: CachedNetworkImage(
                        imageUrl: prompt.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, size: 50),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    prompt.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Model provider badge (larger)
                  if (prompt.modelProvider != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getProviderColor(prompt.modelProvider!).withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${prompt.modelProvider!.displayName} – ${prompt.modelName ?? ""}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getProviderColor(prompt.modelProvider!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Prompt text section
                  const Text(
                    'Prompt',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    prompt.promptText,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Copy button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _copyPrompt(context),
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy Prompt'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),

                  // Negative prompt if exists
                  if (prompt.negativePrompt != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Negative Prompt',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      prompt.negativePrompt!,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Tags
                  if (prompt.tags.isNotEmpty) ...[
                    const Text(
                      'Tags',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: prompt.tags
                          .map((tag) => TagChip(
                                label: tag,
                                isSelected: false,
                                onTap: () {
                                  // Could navigate back to home with filter
                                },
                              ))
                          .toList(),
                    ),
                  ],

                  // Source information
                  if (prompt.sourceUrl != null ||
                      prompt.creatorName != null ||
                      prompt.sourceUserName != null) ...[
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Source Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (prompt.creatorName != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.person, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            prompt.creatorName!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (prompt.sourceUserName != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.account_circle, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '@${prompt.sourceUserName}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (prompt.sourceUrl != null) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _launchUrl(prompt.sourceUrl!),
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('View Original Source'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getProviderColor(ModelProvider provider) {
    switch (provider) {
      case ModelProvider.chatgpt:
        return const Color(0xFF10A37F);
      case ModelProvider.claude:
        return const Color(0xFFCC785C);
      case ModelProvider.gemini:
        return const Color(0xFF4285F4);
      case ModelProvider.other:
        return Colors.grey;
    }
  }

  void _copyPrompt(BuildContext context) {
    Clipboard.setData(ClipboardData(text: prompt.promptText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prompt copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
