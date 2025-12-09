// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PromptModelImpl _$$PromptModelImplFromJson(Map<String, dynamic> json) =>
    _$PromptModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      promptText: json['prompt_text'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      imageUrl: json['image_url'] as String?,
      sourceUrl: json['source_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      modelProvider:
          $enumDecodeNullable(_$ModelProviderEnumMap, json['model_provider']),
      modelName: json['model_name'] as String?,
      negativePrompt: json['negative_prompt'] as String?,
      creatorName: json['creator_name'] as String?,
      sourceUserName: json['source_user_name'] as String?,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdByUserId: json['created_by_user_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PromptModelImplToJson(_$PromptModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'prompt_text': instance.promptText,
      'tags': instance.tags,
      'image_url': instance.imageUrl,
      'source_url': instance.sourceUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'model_provider': instance.modelProvider,
      'model_name': instance.modelName,
      'negative_prompt': instance.negativePrompt,
      'creator_name': instance.creatorName,
      'source_user_name': instance.sourceUserName,
      'is_featured': instance.isFeatured,
      'created_by_user_id': instance.createdByUserId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ModelProviderEnumMap = {
  ModelProvider.chatgpt: 'chatgpt',
  ModelProvider.claude: 'claude',
  ModelProvider.gemini: 'gemini',
  ModelProvider.other: 'other',
};
