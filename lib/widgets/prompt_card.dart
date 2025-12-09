import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/prompt_model.dart';

/// Card widget displaying a single prompt
class PromptCard extends StatelessWidget {
  final PromptModel prompt;

  const PromptCard({
    super.key,
    required this.prompt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100], // Light grey background for the whole card
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          context.push('/prompt/${prompt.id}', extra: prompt);
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section - BIG and TALL rectangle, takes most space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: prompt.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: prompt.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.image, color: Colors.grey, size: 40),
                          ),
                  ),
                ),
              ),
            ),

            // Prompt text description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                prompt.promptText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 4),

            // Bottom row: Model name on left, Copy icon on right
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Model provider with icon
                  if (prompt.modelProvider != null)
                    InkWell(
                      onTap: () => _openAIPlatform(prompt.modelProvider!),
                      borderRadius: BorderRadius.circular(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            prompt.modelProvider!.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(),
                  
                  // Copy button - just icon
                  InkWell(
                    onTap: () => _copyPrompt(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.copy_outlined,
                        size: 16,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
  // Open AI platform website when badge is clicked
  Future<void> _openAIPlatform(ModelProvider provider) async {
    String url;
    switch (provider) {
      case ModelProvider.chatgpt:
        url = 'https://chat.openai.com';
        break;
      case ModelProvider.claude:
        url = 'https://claude.ai';
        break;
      case ModelProvider.gemini:
        url = 'https://gemini.google.com';
        break;
      case ModelProvider.other:
        return; // No URL for other providers
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

