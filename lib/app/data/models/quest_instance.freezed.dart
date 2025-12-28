// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quest_instance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestInstance _$QuestInstanceFromJson(Map<String, dynamic> json) {
  return _QuestInstance.fromJson(json);
}

/// @nodoc
mixin _$QuestInstance {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get templateId => throw _privateConstructorUsedError;
  QuestStatus get status => throw _privateConstructorUsedError;
  int get xpAwarded => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestInstanceCopyWith<QuestInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestInstanceCopyWith<$Res> {
  factory $QuestInstanceCopyWith(
          QuestInstance value, $Res Function(QuestInstance) then) =
      _$QuestInstanceCopyWithImpl<$Res, QuestInstance>;
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String templateId,
      QuestStatus status,
      int xpAwarded,
      String? note});
}

/// @nodoc
class _$QuestInstanceCopyWithImpl<$Res, $Val extends QuestInstance>
    implements $QuestInstanceCopyWith<$Res> {
  _$QuestInstanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? templateId = null,
    Object? status = null,
    Object? xpAwarded = null,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestStatus,
      xpAwarded: null == xpAwarded
          ? _value.xpAwarded
          : xpAwarded // ignore: cast_nullable_to_non_nullable
              as int,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestInstanceImplCopyWith<$Res>
    implements $QuestInstanceCopyWith<$Res> {
  factory _$$QuestInstanceImplCopyWith(
          _$QuestInstanceImpl value, $Res Function(_$QuestInstanceImpl) then) =
      __$$QuestInstanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String templateId,
      QuestStatus status,
      int xpAwarded,
      String? note});
}

/// @nodoc
class __$$QuestInstanceImplCopyWithImpl<$Res>
    extends _$QuestInstanceCopyWithImpl<$Res, _$QuestInstanceImpl>
    implements _$$QuestInstanceImplCopyWith<$Res> {
  __$$QuestInstanceImplCopyWithImpl(
      _$QuestInstanceImpl _value, $Res Function(_$QuestInstanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? templateId = null,
    Object? status = null,
    Object? xpAwarded = null,
    Object? note = freezed,
  }) {
    return _then(_$QuestInstanceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestStatus,
      xpAwarded: null == xpAwarded
          ? _value.xpAwarded
          : xpAwarded // ignore: cast_nullable_to_non_nullable
              as int,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestInstanceImpl implements _QuestInstance {
  const _$QuestInstanceImpl(
      {required this.id,
      required this.date,
      required this.templateId,
      this.status = QuestStatus.todo,
      this.xpAwarded = 0,
      this.note});

  factory _$QuestInstanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestInstanceImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String templateId;
  @override
  @JsonKey()
  final QuestStatus status;
  @override
  @JsonKey()
  final int xpAwarded;
  @override
  final String? note;

  @override
  String toString() {
    return 'QuestInstance(id: $id, date: $date, templateId: $templateId, status: $status, xpAwarded: $xpAwarded, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestInstanceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.xpAwarded, xpAwarded) ||
                other.xpAwarded == xpAwarded) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, date, templateId, status, xpAwarded, note);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestInstanceImplCopyWith<_$QuestInstanceImpl> get copyWith =>
      __$$QuestInstanceImplCopyWithImpl<_$QuestInstanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestInstanceImplToJson(
      this,
    );
  }
}

abstract class _QuestInstance implements QuestInstance {
  const factory _QuestInstance(
      {required final String id,
      required final DateTime date,
      required final String templateId,
      final QuestStatus status,
      final int xpAwarded,
      final String? note}) = _$QuestInstanceImpl;

  factory _QuestInstance.fromJson(Map<String, dynamic> json) =
      _$QuestInstanceImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  String get templateId;
  @override
  QuestStatus get status;
  @override
  int get xpAwarded;
  @override
  String? get note;
  @override
  @JsonKey(ignore: true)
  _$$QuestInstanceImplCopyWith<_$QuestInstanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
