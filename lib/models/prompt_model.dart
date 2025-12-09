import 'package:freezed_annotation/freezed_annotation.dart';

part 'prompt_model.freezed.dart';
part 'prompt_model.g.dart';

/// Enum for AI model providers
enum ModelProvider {
  chatgpt,
  claude,
  gemini,
  other;

  String get displayName {
    switch (this) {
      case ModelProvider.chatgpt:
        return 'ChatGPT';
      case ModelProvider.claude:
        return 'Claude';
      case ModelProvider.gemini:
        return 'Gemini';
      case ModelProvider.other:
        return 'Other';
    }
  }

  String toJson() => name;

  static ModelProvider fromJson(String json) {
    return ModelProvider.values.firstWhere(
      (provider) => provider.name == json,
      orElse: () => ModelProvider.other,
    );
  }
}

/// Prompt model for Supabase
@freezed
class PromptModel with _$PromptModel {
  const factory PromptModel({
    required String id,
    required String title,
    @JsonKey(name: 'prompt_text') required String promptText,
    @Default([]) List<String> tags,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'source_url') String? sourceUrl,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @JsonKey(name: 'model_provider') ModelProvider? modelProvider,
    @JsonKey(name: 'model_name') String? modelName,
    @JsonKey(name: 'negative_prompt') String? negativePrompt,
    @JsonKey(name: 'creator_name') String? creatorName,
    @JsonKey(name: 'source_user_name') String? sourceUserName,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'created_by_user_id') String? createdByUserId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PromptModel;

  factory PromptModel.fromJson(Map<String, dynamic> json) =>
      _$PromptModelFromJson(json);
}
