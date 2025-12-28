// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlanItem _$PlanItemFromJson(Map<String, dynamic> json) {
  return _PlanItem.fromJson(json);
}

/// @nodoc
mixin _$PlanItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get time => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  PlanStatus get status => throw _privateConstructorUsedError;
  String? get linkedQuestId => throw _privateConstructorUsedError;
  String? get notes =>
      throw _privateConstructorUsedError; // Quantity and unit tracking (for tasks like "Walk 10 minutes", "Do 3 sets")
  int get quantity =>
      throw _privateConstructorUsedError; // Quantity (e.g., 10 for "10 minutes", 3 for "3 sets")
  ItemUnit get unit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlanItemCopyWith<PlanItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanItemCopyWith<$Res> {
  factory $PlanItemCopyWith(PlanItem value, $Res Function(PlanItem) then) =
      _$PlanItemCopyWithImpl<$Res, PlanItem>;
  @useResult
  $Res call(
      {String id,
      String title,
      DateTime date,
      String? time,
      String category,
      PlanStatus status,
      String? linkedQuestId,
      String? notes,
      int quantity,
      ItemUnit unit});

  $ItemUnitCopyWith<$Res> get unit;
}

/// @nodoc
class _$PlanItemCopyWithImpl<$Res, $Val extends PlanItem>
    implements $PlanItemCopyWith<$Res> {
  _$PlanItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? date = null,
    Object? time = freezed,
    Object? category = null,
    Object? status = null,
    Object? linkedQuestId = freezed,
    Object? notes = freezed,
    Object? quantity = null,
    Object? unit = null,
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
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlanStatus,
      linkedQuestId: freezed == linkedQuestId
          ? _value.linkedQuestId
          : linkedQuestId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as ItemUnit,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ItemUnitCopyWith<$Res> get unit {
    return $ItemUnitCopyWith<$Res>(_value.unit, (value) {
      return _then(_value.copyWith(unit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlanItemImplCopyWith<$Res>
    implements $PlanItemCopyWith<$Res> {
  factory _$$PlanItemImplCopyWith(
          _$PlanItemImpl value, $Res Function(_$PlanItemImpl) then) =
      __$$PlanItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      DateTime date,
      String? time,
      String category,
      PlanStatus status,
      String? linkedQuestId,
      String? notes,
      int quantity,
      ItemUnit unit});

  @override
  $ItemUnitCopyWith<$Res> get unit;
}

/// @nodoc
class __$$PlanItemImplCopyWithImpl<$Res>
    extends _$PlanItemCopyWithImpl<$Res, _$PlanItemImpl>
    implements _$$PlanItemImplCopyWith<$Res> {
  __$$PlanItemImplCopyWithImpl(
      _$PlanItemImpl _value, $Res Function(_$PlanItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? date = null,
    Object? time = freezed,
    Object? category = null,
    Object? status = null,
    Object? linkedQuestId = freezed,
    Object? notes = freezed,
    Object? quantity = null,
    Object? unit = null,
  }) {
    return _then(_$PlanItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlanStatus,
      linkedQuestId: freezed == linkedQuestId
          ? _value.linkedQuestId
          : linkedQuestId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as ItemUnit,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanItemImpl implements _PlanItem {
  const _$PlanItemImpl(
      {required this.id,
      required this.title,
      required this.date,
      this.time,
      this.category = '',
      this.status = PlanStatus.pending,
      this.linkedQuestId,
      this.notes,
      this.quantity = 0,
      this.unit = const ItemUnit()});

  factory _$PlanItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final DateTime date;
  @override
  final String? time;
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final PlanStatus status;
  @override
  final String? linkedQuestId;
  @override
  final String? notes;
// Quantity and unit tracking (for tasks like "Walk 10 minutes", "Do 3 sets")
  @override
  @JsonKey()
  final int quantity;
// Quantity (e.g., 10 for "10 minutes", 3 for "3 sets")
  @override
  @JsonKey()
  final ItemUnit unit;

  @override
  String toString() {
    return 'PlanItem(id: $id, title: $title, date: $date, time: $time, category: $category, status: $status, linkedQuestId: $linkedQuestId, notes: $notes, quantity: $quantity, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.linkedQuestId, linkedQuestId) ||
                other.linkedQuestId == linkedQuestId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, date, time, category,
      status, linkedQuestId, notes, quantity, unit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanItemImplCopyWith<_$PlanItemImpl> get copyWith =>
      __$$PlanItemImplCopyWithImpl<_$PlanItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanItemImplToJson(
      this,
    );
  }
}

abstract class _PlanItem implements PlanItem {
  const factory _PlanItem(
      {required final String id,
      required final String title,
      required final DateTime date,
      final String? time,
      final String category,
      final PlanStatus status,
      final String? linkedQuestId,
      final String? notes,
      final int quantity,
      final ItemUnit unit}) = _$PlanItemImpl;

  factory _PlanItem.fromJson(Map<String, dynamic> json) =
      _$PlanItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  DateTime get date;
  @override
  String? get time;
  @override
  String get category;
  @override
  PlanStatus get status;
  @override
  String? get linkedQuestId;
  @override
  String? get notes;
  @override // Quantity and unit tracking (for tasks like "Walk 10 minutes", "Do 3 sets")
  int get quantity;
  @override // Quantity (e.g., 10 for "10 minutes", 3 for "3 sets")
  ItemUnit get unit;
  @override
  @JsonKey(ignore: true)
  _$$PlanItemImplCopyWith<_$PlanItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
