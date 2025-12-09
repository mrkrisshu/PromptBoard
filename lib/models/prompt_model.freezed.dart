// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prompt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PromptModel _$PromptModelFromJson(Map<String, dynamic> json) {
  return _PromptModel.fromJson(json);
}

/// @nodoc
mixin _$PromptModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'prompt_text')
  String get promptText => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_url')
  String? get sourceUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'model_provider')
  ModelProvider? get modelProvider => throw _privateConstructorUsedError;
  @JsonKey(name: 'model_name')
  String? get modelName => throw _privateConstructorUsedError;
  @JsonKey(name: 'negative_prompt')
  String? get negativePrompt => throw _privateConstructorUsedError;
  @JsonKey(name: 'creator_name')
  String? get creatorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_user_name')
  String? get sourceUserName => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_featured')
  bool get isFeatured => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by_user_id')
  String? get createdByUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PromptModelCopyWith<PromptModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromptModelCopyWith<$Res> {
  factory $PromptModelCopyWith(
          PromptModel value, $Res Function(PromptModel) then) =
      _$PromptModelCopyWithImpl<$Res, PromptModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'prompt_text') String promptText,
      List<String> tags,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'source_url') String? sourceUrl,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @JsonKey(name: 'model_provider') ModelProvider? modelProvider,
      @JsonKey(name: 'model_name') String? modelName,
      @JsonKey(name: 'negative_prompt') String? negativePrompt,
      @JsonKey(name: 'creator_name') String? creatorName,
      @JsonKey(name: 'source_user_name') String? sourceUserName,
      @JsonKey(name: 'is_featured') bool isFeatured,
      @JsonKey(name: 'created_by_user_id') String? createdByUserId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$PromptModelCopyWithImpl<$Res, $Val extends PromptModel>
    implements $PromptModelCopyWith<$Res> {
  _$PromptModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? promptText = null,
    Object? tags = null,
    Object? imageUrl = freezed,
    Object? sourceUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? modelProvider = freezed,
    Object? modelName = freezed,
    Object? negativePrompt = freezed,
    Object? creatorName = freezed,
    Object? sourceUserName = freezed,
    Object? isFeatured = null,
    Object? createdByUserId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      promptText: null == promptText
          ? _value.promptText
          : promptText // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceUrl: freezed == sourceUrl
          ? _value.sourceUrl
          : sourceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      modelProvider: freezed == modelProvider
          ? _value.modelProvider
          : modelProvider // ignore: cast_nullable_to_non_nullable
              as ModelProvider?,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      negativePrompt: freezed == negativePrompt
          ? _value.negativePrompt
          : negativePrompt // ignore: cast_nullable_to_non_nullable
              as String?,
      creatorName: freezed == creatorName
          ? _value.creatorName
          : creatorName // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceUserName: freezed == sourceUserName
          ? _value.sourceUserName
          : sourceUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdByUserId: freezed == createdByUserId
          ? _value.createdByUserId
          : createdByUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PromptModelImplCopyWith<$Res>
    implements $PromptModelCopyWith<$Res> {
  factory _$$PromptModelImplCopyWith(
          _$PromptModelImpl value, $Res Function(_$PromptModelImpl) then) =
      __$$PromptModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'prompt_text') String promptText,
      List<String> tags,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'source_url') String? sourceUrl,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @JsonKey(name: 'model_provider') ModelProvider? modelProvider,
      @JsonKey(name: 'model_name') String? modelName,
      @JsonKey(name: 'negative_prompt') String? negativePrompt,
      @JsonKey(name: 'creator_name') String? creatorName,
      @JsonKey(name: 'source_user_name') String? sourceUserName,
      @JsonKey(name: 'is_featured') bool isFeatured,
      @JsonKey(name: 'created_by_user_id') String? createdByUserId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$PromptModelImplCopyWithImpl<$Res>
    extends _$PromptModelCopyWithImpl<$Res, _$PromptModelImpl>
    implements _$$PromptModelImplCopyWith<$Res> {
  __$$PromptModelImplCopyWithImpl(
      _$PromptModelImpl _value, $Res Function(_$PromptModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? promptText = null,
    Object? tags = null,
    Object? imageUrl = freezed,
    Object? sourceUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? modelProvider = freezed,
    Object? modelName = freezed,
    Object? negativePrompt = freezed,
    Object? creatorName = freezed,
    Object? sourceUserName = freezed,
    Object? isFeatured = null,
    Object? createdByUserId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PromptModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      promptText: null == promptText
          ? _value.promptText
          : promptText // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceUrl: freezed == sourceUrl
          ? _value.sourceUrl
          : sourceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      modelProvider: freezed == modelProvider
          ? _value.modelProvider
          : modelProvider // ignore: cast_nullable_to_non_nullable
              as ModelProvider?,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      negativePrompt: freezed == negativePrompt
          ? _value.negativePrompt
          : negativePrompt // ignore: cast_nullable_to_non_nullable
              as String?,
      creatorName: freezed == creatorName
          ? _value.creatorName
          : creatorName // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceUserName: freezed == sourceUserName
          ? _value.sourceUserName
          : sourceUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdByUserId: freezed == createdByUserId
          ? _value.createdByUserId
          : createdByUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PromptModelImpl implements _PromptModel {
  const _$PromptModelImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'prompt_text') required this.promptText,
      final List<String> tags = const [],
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'source_url') this.sourceUrl,
      @JsonKey(name: 'thumbnail_url') this.thumbnailUrl,
      @JsonKey(name: 'model_provider') this.modelProvider,
      @JsonKey(name: 'model_name') this.modelName,
      @JsonKey(name: 'negative_prompt') this.negativePrompt,
      @JsonKey(name: 'creator_name') this.creatorName,
      @JsonKey(name: 'source_user_name') this.sourceUserName,
      @JsonKey(name: 'is_featured') this.isFeatured = false,
      @JsonKey(name: 'created_by_user_id') this.createdByUserId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _tags = tags;

  factory _$PromptModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromptModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey(name: 'prompt_text')
  final String promptText;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'source_url')
  final String? sourceUrl;
  @override
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @override
  @JsonKey(name: 'model_provider')
  final ModelProvider? modelProvider;
  @override
  @JsonKey(name: 'model_name')
  final String? modelName;
  @override
  @JsonKey(name: 'negative_prompt')
  final String? negativePrompt;
  @override
  @JsonKey(name: 'creator_name')
  final String? creatorName;
  @override
  @JsonKey(name: 'source_user_name')
  final String? sourceUserName;
  @override
  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  @override
  @JsonKey(name: 'created_by_user_id')
  final String? createdByUserId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PromptModel(id: $id, title: $title, promptText: $promptText, tags: $tags, imageUrl: $imageUrl, sourceUrl: $sourceUrl, thumbnailUrl: $thumbnailUrl, modelProvider: $modelProvider, modelName: $modelName, negativePrompt: $negativePrompt, creatorName: $creatorName, sourceUserName: $sourceUserName, isFeatured: $isFeatured, createdByUserId: $createdByUserId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromptModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.promptText, promptText) ||
                other.promptText == promptText) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.sourceUrl, sourceUrl) ||
                other.sourceUrl == sourceUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.modelProvider, modelProvider) ||
                other.modelProvider == modelProvider) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.negativePrompt, negativePrompt) ||
                other.negativePrompt == negativePrompt) &&
            (identical(other.creatorName, creatorName) ||
                other.creatorName == creatorName) &&
            (identical(other.sourceUserName, sourceUserName) ||
                other.sourceUserName == sourceUserName) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.createdByUserId, createdByUserId) ||
                other.createdByUserId == createdByUserId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      promptText,
      const DeepCollectionEquality().hash(_tags),
      imageUrl,
      sourceUrl,
      thumbnailUrl,
      modelProvider,
      modelName,
      negativePrompt,
      creatorName,
      sourceUserName,
      isFeatured,
      createdByUserId,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PromptModelImplCopyWith<_$PromptModelImpl> get copyWith =>
      __$$PromptModelImplCopyWithImpl<_$PromptModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromptModelImplToJson(
      this,
    );
  }
}

abstract class _PromptModel implements PromptModel {
  const factory _PromptModel(
          {required final String id,
          required final String title,
          @JsonKey(name: 'prompt_text') required final String promptText,
          final List<String> tags,
          @JsonKey(name: 'image_url') final String? imageUrl,
          @JsonKey(name: 'source_url') final String? sourceUrl,
          @JsonKey(name: 'thumbnail_url') final String? thumbnailUrl,
          @JsonKey(name: 'model_provider') final ModelProvider? modelProvider,
          @JsonKey(name: 'model_name') final String? modelName,
          @JsonKey(name: 'negative_prompt') final String? negativePrompt,
          @JsonKey(name: 'creator_name') final String? creatorName,
          @JsonKey(name: 'source_user_name') final String? sourceUserName,
          @JsonKey(name: 'is_featured') final bool isFeatured,
          @JsonKey(name: 'created_by_user_id') final String? createdByUserId,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$PromptModelImpl;

  factory _PromptModel.fromJson(Map<String, dynamic> json) =
      _$PromptModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'prompt_text')
  String get promptText;
  @override
  List<String> get tags;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'source_url')
  String? get sourceUrl;
  @override
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl;
  @override
  @JsonKey(name: 'model_provider')
  ModelProvider? get modelProvider;
  @override
  @JsonKey(name: 'model_name')
  String? get modelName;
  @override
  @JsonKey(name: 'negative_prompt')
  String? get negativePrompt;
  @override
  @JsonKey(name: 'creator_name')
  String? get creatorName;
  @override
  @JsonKey(name: 'source_user_name')
  String? get sourceUserName;
  @override
  @JsonKey(name: 'is_featured')
  bool get isFeatured;
  @override
  @JsonKey(name: 'created_by_user_id')
  String? get createdByUserId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PromptModelImplCopyWith<_$PromptModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
