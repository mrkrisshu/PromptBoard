import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'app_user_role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model representing a user document in Firestore
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required AppUserRole role,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      role: AppUserRole.fromJson(data['role'] ?? 'user'),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert UserModel to Firestore document
  static Map<String, dynamic> toFirestore(UserModel user) {
    return {
      'email': user.email,
      'role': user.role.toJson(),
      'createdAt': Timestamp.fromDate(user.createdAt),
      'updatedAt': Timestamp.fromDate(user.updatedAt),
    };
  }
}
