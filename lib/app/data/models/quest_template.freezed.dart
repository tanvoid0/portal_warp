// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quest_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestTemplate _$QuestTemplateFromJson(Map<String, dynamic> json) {
  return _QuestTemplate.fromJson(json);
}

/// @nodoc
mixin _$QuestTemplate {
  String get id => throw _privateConstructorUsedError;
  FocusArea get focusAreaId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get durationBucket =>
      throw _privateConstructorUsedError; // 2, 10, or 30 minutes
  int get difficulty => throw _privateConstructorUsedError; // 1-5
  int get cooldownDays => throw _privateConstructorUsedError;
  String get instructions => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestTemplateCopyWith<QuestTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestTemplateCopyWith<$Res> {
  factory $QuestTemplateCopyWith(
          QuestTemplate value, $Res Function(QuestTemplate) then) =
      _$QuestTemplateCopyWithImpl<$Res, QuestTemplate>;
  @useResult
  $Res call(
      {String id,
      FocusArea focusAreaId,
      String title,
      int durationBucket,
      int difficulty,
      int cooldownDays,
      String instructions,
      List<String> tags});
}

/// @nodoc
class _$QuestTemplateCopyWithImpl<$Res, $Val extends QuestTemplate>
    implements $QuestTemplateCopyWith<$Res> {
  _$QuestTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? focusAreaId = null,
    Object? title = null,
    Object? durationBucket = null,
    Object? difficulty = null,
    Object? cooldownDays = null,
    Object? instructions = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      focusAreaId: null == focusAreaId
          ? _value.focusAreaId
          : focusAreaId // ignore: cast_nullable_to_non_nullable
              as FocusArea,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      durationBucket: null == durationBucket
          ? _value.durationBucket
          : durationBucket // ignore: cast_nullable_to_non_nullable
              as int,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      cooldownDays: null == cooldownDays
          ? _value.cooldownDays
          : cooldownDays // ignore: cast_nullable_to_non_nullable
              as int,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestTemplateImplCopyWith<$Res>
    implements $QuestTemplateCopyWith<$Res> {
  factory _$$QuestTemplateImplCopyWith(
          _$QuestTemplateImpl value, $Res Function(_$QuestTemplateImpl) then) =
      __$$QuestTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      FocusArea focusAreaId,
      String title,
      int durationBucket,
      int difficulty,
      int cooldownDays,
      String instructions,
      List<String> tags});
}

/// @nodoc
class __$$QuestTemplateImplCopyWithImpl<$Res>
    extends _$QuestTemplateCopyWithImpl<$Res, _$QuestTemplateImpl>
    implements _$$QuestTemplateImplCopyWith<$Res> {
  __$$QuestTemplateImplCopyWithImpl(
      _$QuestTemplateImpl _value, $Res Function(_$QuestTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? focusAreaId = null,
    Object? title = null,
    Object? durationBucket = null,
    Object? difficulty = null,
    Object? cooldownDays = null,
    Object? instructions = null,
    Object? tags = null,
  }) {
    return _then(_$QuestTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      focusAreaId: null == focusAreaId
          ? _value.focusAreaId
          : focusAreaId // ignore: cast_nullable_to_non_nullable
              as FocusArea,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      durationBucket: null == durationBucket
          ? _value.durationBucket
          : durationBucket // ignore: cast_nullable_to_non_nullable
              as int,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      cooldownDays: null == cooldownDays
          ? _value.cooldownDays
          : cooldownDays // ignore: cast_nullable_to_non_nullable
              as int,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestTemplateImpl implements _QuestTemplate {
  const _$QuestTemplateImpl(
      {required this.id,
      required this.focusAreaId,
      required this.title,
      this.durationBucket = 10,
      this.difficulty = 3,
      this.cooldownDays = 0,
      this.instructions = '',
      final List<String> tags = const []})
      : _tags = tags;

  factory _$QuestTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final FocusArea focusAreaId;
  @override
  final String title;
  @override
  @JsonKey()
  final int durationBucket;
// 2, 10, or 30 minutes
  @override
  @JsonKey()
  final int difficulty;
// 1-5
  @override
  @JsonKey()
  final int cooldownDays;
  @override
  @JsonKey()
  final String instructions;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'QuestTemplate(id: $id, focusAreaId: $focusAreaId, title: $title, durationBucket: $durationBucket, difficulty: $difficulty, cooldownDays: $cooldownDays, instructions: $instructions, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.focusAreaId, focusAreaId) ||
                other.focusAreaId == focusAreaId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.durationBucket, durationBucket) ||
                other.durationBucket == durationBucket) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.cooldownDays, cooldownDays) ||
                other.cooldownDays == cooldownDays) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      focusAreaId,
      title,
      durationBucket,
      difficulty,
      cooldownDays,
      instructions,
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestTemplateImplCopyWith<_$QuestTemplateImpl> get copyWith =>
      __$$QuestTemplateImplCopyWithImpl<_$QuestTemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestTemplateImplToJson(
      this,
    );
  }
}

abstract class _QuestTemplate implements QuestTemplate {
  const factory _QuestTemplate(
      {required final String id,
      required final FocusArea focusAreaId,
      required final String title,
      final int durationBucket,
      final int difficulty,
      final int cooldownDays,
      final String instructions,
      final List<String> tags}) = _$QuestTemplateImpl;

  factory _QuestTemplate.fromJson(Map<String, dynamic> json) =
      _$QuestTemplateImpl.fromJson;

  @override
  String get id;
  @override
  FocusArea get focusAreaId;
  @override
  String get title;
  @override
  int get durationBucket;
  @override // 2, 10, or 30 minutes
  int get difficulty;
  @override // 1-5
  int get cooldownDays;
  @override
  String get instructions;
  @override
  List<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$QuestTemplateImplCopyWith<_$QuestTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
