import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/prompt_model.dart';

/// Seed data script for creating sample prompts
/// Run this from admin panel or as a one-time initialization
class SeedDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedPrompts(String adminUserId) async {
    final now = DateTime.now();

    final samplePrompts = [
      // ChatGPT - GPT-4.1 prompts
      PromptModel(
        id: '',
        title: 'Cinematic Golden Hour Portrait',
        promptText: 'A cinematic portrait of a woman standing in a golden hour field, soft backlight, warm tones, shallow depth of field, professional photography, 8k uhd, DSLR, film grain, Fujifilm XT3',
        tags: ['Cinematic', 'Golden-Hour', 'Portrait', 'Photography'],
        imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800',
        sourceUrl: 'https://unsplash.com/photos/example',
        modelProvider: ModelProvider.chatgpt,
        modelName: 'GPT-4.1',
        creatorName: 'Sample Creator',
        isFeatured: true,
        createdByUserId: adminUserId,
        createdAt: now,
        updatedAt: now,
      ),

      PromptModel(
        id: '',
        title: 'Fantasy Landscape Concept Art',
        promptText: 'Epic fantasy landscape, floating islands, waterfalls cascading into clouds, magical atmosphere, vibrant colors, concept art style, highly detailed, trending on artstation, dramatic lighting',
        tags: ['Fantasy', 'Landscape', 'Concept-Art', 'Digital-Art'],
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
        modelProvider: ModelProvider.chatgpt,
        modelName: 'GPT-4.1 mini',
        isFeatured: true,
        createdByUserId: adminUserId,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),

      // Claude prompts
      PromptModel(
        id: '',
        title: 'Modern Minimalist Interior',
        promptText: 'Modern minimalist living room, Scandinavian design, natural light streaming through large windows, neutral color palette, clean lines, indoor plants, cozy atmosphere, architectural photography',
        tags: ['Interior', 'Minimalist', 'Architecture', 'Modern'],
        imageUrl: 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=800',
        modelProvider: ModelProvider.claude,
        modelName: 'Claude 4.5 Sonnet',
        negativePrompt: 'cluttered, dark, messy, outdated furniture',
        isFeatured: false,
        createdByUserId: adminUserId,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),

      PromptModel(
        id: '',
        title: 'Cyberpunk Street Scene',
        promptText: 'Cyberpunk Tokyo street at night, neon signs reflecting on wet pavement, rain, futuristic atmosphere, people with umbrellas, flying cars in background, cinematic composition, blade runner aesthetic',
        tags: ['Cyberpunk', 'Urban', 'Sci-Fi', 'Night'],
        imageUrl: 'https://images.unsplash.com/photo-1542281286-9e0a16bb7366?w=800',
        sourceUrl: 'https://www.instagram.com/p/example',
        sourceUserName: 'cyberpunk_artist',
        modelProvider: ModelProvider.claude,
        modelName: 'Claude 3.5 Sonnet',
        isFeatured: true,
        createdByUserId: adminUserId,
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ),

      // Gemini prompts
      PromptModel(
        id: '',
        title: 'Whimsical Forest Creatures',
        promptText: 'Magical forest scene with cute fantasy creatures, glowing mushrooms, fairy lights, enchanted atmosphere, soft pastel colors, children\'s book illustration style, highly detailed, whimsical',
        tags: ['Fantasy', 'Illustration', 'Whimsical', 'Nature'],
        imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
        modelProvider: ModelProvider.gemini,
        modelName: 'Gemini 2.5',
        isFeatured: false,
        createdByUserId: adminUserId,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 4)),
      ),

      PromptModel(
        id: '',
        title: 'Abstract Geometric Art',
        promptText: 'Abstract geometric composition, bold colors, overlapping shapes, modern art style, vibrant gradients, dynamic composition, high contrast, digital art, 4k resolution',
        tags: ['Abstract', 'Geometric', 'Modern-Art', 'Colorful'],
        imageUrl: 'https://images.unsplash.com/photo-1557672172-298e090bd0f1?w=800',
        modelProvider: ModelProvider.gemini,
        modelName: 'Gemini 2.0 Flash',
        negativePrompt: 'blurry, low quality, messy, unclear shapes',
        isFeatured: true,
        createdByUserId: adminUserId,
        createdAt: now.subtract(const Duration(hours: 5)),
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),

      // Additional diverse prompts
      PromptModel(
        id: '',
        title: 'Vintage Car Photography',
        promptText: 'Classic vintage car, 1960s muscle car, chrome details, sunset lighting, desert backdrop, automotive photography, shallow depth of field, nostalgic atmosphere',
        tags: ['Vintage', 'Automotive', 'Photography', 'Retro'],
        imageUrl: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800',
        modelProvider: ModelProvider.chatgpt,
        modelName: 'GPT-4.1',
        isFeatured: false,
        createdByUserId: adminUserId,
        createdAt: now.subtract(const Duration(hours: 6)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),

      PromptModel(
        id: '',
        title: 'Underwater Ocean Scene',
        promptText: 'Underwater scene, coral reef, tropical fish, rays of sunlight penetrating water, crystal clear water, vibrant marine life, professional underwater photography, 8k, photorealistic',
        tags: ['Underwater', 'Nature', 'Ocean', 'Photography'],
        imageUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
        modelProvider: ModelProvider.gemini,
        modelName: 'Gemini 2.5',
        isFeatured: true,
        createdByUserId: adminUserId,
        createdAt: now.subtract(const Duration(hours: 7)),
        updatedAt: now.subtract(const Duration(hours: 7)),
      ),
    ];

    // Batch create prompts
    final batch = _firestore.batch();

    for (final prompt in samplePrompts) {
      final docRef = _firestore.collection('prompts').doc();
      batch.set(docRef, PromptModel.toFirestore(prompt));
    }

    await batch.commit();
    print('✅ Successfully seeded ${samplePrompts.length} prompts');
  }

  /// Create admin user document
  Future<void> createAdminUser(String userId, String email) async {
    await _firestore.collection('users').doc(userId).set({
      'email': email,
      'role': 'admin',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    print('✅ Created admin user: $email');
  }
}
