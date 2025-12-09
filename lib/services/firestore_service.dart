import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prompt_model.dart';

/// Service for Firestore database operations
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get prompts collection reference
  CollectionReference get promptsCollection => _firestore.collection('prompts');

  /// Get users collection reference
  CollectionReference get usersCollection => _firestore.collection('users');

  /// Stream of all prompts ordered by creation date
  Stream<List<PromptModel>> getPromptsStream() {
    return promptsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PromptModel.fromFirestore(doc))
            .toList());
  }

  /// Get prompts once (for initial load)
  Future<List<PromptModel>> getPrompts() async {
    final snapshot = await promptsCollection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => PromptModel.fromFirestore(doc))
        .toList();
  }

  /// Get featured prompts
  Future<List<PromptModel>> getFeaturedPrompts() async {
    final snapshot = await promptsCollection
        .where('isFeatured', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => PromptModel.fromFirestore(doc))
        .toList();
  }

  /// Get single prompt by ID
  Future<PromptModel?> getPromptById(String id) async {
    final doc = await promptsCollection.doc(id).get();
    if (!doc.exists) return null;
    return PromptModel.fromFirestore(doc);
  }

  /// Create new prompt
  Future<String> createPrompt(PromptModel prompt) async {
    final docRef = await promptsCollection.add(PromptModel.toFirestore(prompt));
    return docRef.id;
  }

  /// Update existing prompt
  Future<void> updatePrompt(PromptModel prompt) async {
    await promptsCollection.doc(prompt.id).update(PromptModel.toFirestore(prompt));
  }

  /// Delete prompt
  Future<void> deletePrompt(String promptId) async {
    await promptsCollection.doc(promptId).delete();
  }

  /// Get all unique tags from prompts
  Future<List<String>> getAllTags() async {
    final snapshot = await promptsCollection.get();
    final tags = <String>{};

    for (final doc in snapshot.docs) {
      final prompt = PromptModel.fromFirestore(doc);
      tags.addAll(prompt.tags);
    }

    return tags.toList()..sort();
  }

  /// Batch create prompts (for seeding)
  Future<void> batchCreatePrompts(List<PromptModel> prompts) async {
    final batch = _firestore.batch();

    for (final prompt in prompts) {
      final docRef = promptsCollection.doc();
      batch.set(docRef, PromptModel.toFirestore(prompt));
    }

    await batch.commit();
  }
}
