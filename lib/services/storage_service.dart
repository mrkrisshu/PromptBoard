import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Service for Firebase Storage operations
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload image to Firebase Storage
  /// Returns the download URL
  Future<String> uploadPromptImage({
    required String promptId,
    required File imageFile,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final ref = _storage.ref().child('prompts/$promptId/$fileName');

      // Upload file
      final uploadTask = await ref.putFile(imageFile);

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Delete image from Firebase Storage
  Future<void> deletePromptImage(String imageUrl) async {
    try {
      // Extract path from URL
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Silently fail if image doesn't exist or can't be deleted
      print('Failed to delete image: $e');
    }
  }

  /// Delete all images for a prompt
  Future<void> deletePromptImages(String promptId) async {
    try {
      final ref = _storage.ref().child('prompts/$promptId');
      final list = await ref.listAll();

      // Delete all files in the folder
      for (final item in list.items) {
        await item.delete();
      }
    } catch (e) {
      print('Failed to delete prompt images: $e');
    }
  }
}
