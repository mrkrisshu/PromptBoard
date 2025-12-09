import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/app_user_role.dart';

/// Service for Firebase Authentication
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Sign in with email and password (for admin)
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign in anonymously (for regular users)
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get user role from Firestore
  Future<AppUserRole> getUserRole(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final userData = UserModel.fromFirestore(doc);
        return userData.role;
      }
      return AppUserRole.user;
    } catch (e) {
      return AppUserRole.user;
    }
  }

  /// Create user document in Firestore
  Future<void> createUserDocument({
    required String userId,
    required String email,
    AppUserRole role = AppUserRole.user,
  }) async {
    final userDoc = _firestore.collection('users').doc(userId);
    final exists = await userDoc.get();

    if (!exists.exists) {
      final now = DateTime.now();
      final user = UserModel(
        id: userId,
        email: email,
        role: role,
        createdAt: now,
        updatedAt: now,
      );

      await userDoc.set(UserModel.toFirestore(user));
    }
  }

  /// Check if user is admin
  Future<bool> isAdmin() async {
    final user = currentUser;
    if (user == null) return false;

    final role = await getUserRole(user.uid);
    return role == AppUserRole.admin;
  }
}
