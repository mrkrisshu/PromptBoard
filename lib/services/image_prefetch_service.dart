import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/prompt_model.dart';

/// Service for prefetching images to warm up cache
class ImagePrefetchService {
  /// Prefetch images for a list of prompts
  /// Warms up the cached_network_image cache for faster subsequent loads
  static Future<void> prefetchPromptImages(
    BuildContext context,
    List<PromptModel> prompts, {
    int maxCount = 10,
  }) async {
    final imagesToPrefetch = prompts
        .take(maxCount)
        .where((p) => p.imageUrl != null && p.imageUrl!.isNotEmpty)
        .map((p) => p.imageUrl!)
        .toList();

    final prefetchFutures = imagesToPrefetch.map((url) async {
      try {
        // Use CachedNetworkImageProvider to prefetch
        final provider = CachedNetworkImageProvider(url);
        await precacheImage(provider, context);
      } catch (e) {
        // Silently fail for individual images
        debugPrint('Failed to prefetch image: $url');
      }
    });

    await Future.wait(prefetchFutures);
  }
}
