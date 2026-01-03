// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drawer_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DrawerItem _$DrawerItemFromJson(Map<String, dynamic> json) {
  return _DrawerItem.fromJson(json);
}

/// @nodoc
mixin _$DrawerItem {
  String get id => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  DrawerStatus get status => throw _privateConstructorUsedError;
  DateTime? get lastOrganized => throw _privateConstructorUsedError;
  String? get notes =>
      throw _privateConstructorUsedError; // Quantity and unit tracking
  int get currentQuantity =>
      throw _privateConstructorUsedError; // Current count (e.g., 3)
  int get targetQuantity =>
      throw _privateConstructorUsedError; // Target count (e.g., 5)
  ItemUnit get unit =>
      throw _privateConstructorUsedError; // Unit type (e.g., "pieces", "pairs", "t-shirts")
// Style/occasion tags (e.g., "casual", "formal", "home", "work", "sport", "party")
  List<String> get styles => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DrawerItemCopyWith<DrawerItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DrawerItemCopyWith<$Res> {
  factory $DrawerItemCopyWith(
          DrawerItem value, $Res Function(DrawerItem) then) =
      _$DrawerItemCopyWithImpl<$Res, DrawerItem>;
  @useResult
  $Res call(
      {String id,
      String category,
      String name,
      String location,
      DrawerStatus status,
      DateTime? lastOrganized,
      String? notes,
      int currentQuantity,
      int targetQuantity,
      ItemUnit unit,
      List<String> styles});

  $ItemUnitCopyWith<$Res> get unit;
}

/// @nodoc
class _$DrawerItemCopyWithImpl<$Res, $Val extends DrawerItem>
    implements $DrawerItemCopyWith<$Res> {
  _$DrawerItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? name = null,
    Object? location = null,
    Object? status = null,
    Object? lastOrganized = freezed,
    Object? notes = freezed,
    Object? currentQuantity = null,
    Object? targetQuantity = null,
    Object? unit = null,
    Object? styles = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DrawerStatus,
      lastOrganized: freezed == lastOrganized
          ? _value.lastOrganized
          : lastOrganized // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      currentQuantity: null == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      targetQuantity: null == targetQuantity
          ? _value.targetQuantity
          : targetQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as ItemUnit,
      styles: null == styles
          ? _value.styles
          : styles // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
abstract class _$$DrawerItemImplCopyWith<$Res>
    implements $DrawerItemCopyWith<$Res> {
  factory _$$DrawerItemImplCopyWith(
          _$DrawerItemImpl value, $Res Function(_$DrawerItemImpl) then) =
      __$$DrawerItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String category,
      String name,
      String location,
      DrawerStatus status,
      DateTime? lastOrganized,
      String? notes,
      int currentQuantity,
      int targetQuantity,
      ItemUnit unit,
      List<String> styles});

  @override
  $ItemUnitCopyWith<$Res> get unit;
}

/// @nodoc
class __$$DrawerItemImplCopyWithImpl<$Res>
    extends _$DrawerItemCopyWithImpl<$Res, _$DrawerItemImpl>
    implements _$$DrawerItemImplCopyWith<$Res> {
  __$$DrawerItemImplCopyWithImpl(
      _$DrawerItemImpl _value, $Res Function(_$DrawerItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? name = null,
    Object? location = null,
    Object? status = null,
    Object? lastOrganized = freezed,
    Object? notes = freezed,
    Object? currentQuantity = null,
    Object? targetQuantity = null,
    Object? unit = null,
    Object? styles = null,
  }) {
    return _then(_$DrawerItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DrawerStatus,
      lastOrganized: freezed == lastOrganized
          ? _value.lastOrganized
          : lastOrganized // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      currentQuantity: null == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      targetQuantity: null == targetQuantity
          ? _value.targetQuantity
          : targetQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as ItemUnit,
      styles: null == styles
          ? _value._styles
          : styles // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DrawerItemImpl implements _DrawerItem {
  const _$DrawerItemImpl(
      {required this.id,
      this.category = '',
      required this.name,
      this.location = '',
      this.status = DrawerStatus.unorganized,
      this.lastOrganized,
      this.notes,
      this.currentQuantity = 0,
      this.targetQuantity = 0,
      this.unit = const ItemUnit(),
      final List<String> styles = const []})
      : _styles = styles;

  factory _$DrawerItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$DrawerItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String category;
  @override
  final String name;
  @override
  @JsonKey()
  final String location;
  @override
  @JsonKey()
  final DrawerStatus status;
  @override
  final DateTime? lastOrganized;
  @override
  final String? notes;
// Quantity and unit tracking
  @override
  @JsonKey()
  final int currentQuantity;
// Current count (e.g., 3)
  @override
  @JsonKey()
  final int targetQuantity;
// Target count (e.g., 5)
  @override
  @JsonKey()
  final ItemUnit unit;
// Unit type (e.g., "pieces", "pairs", "t-shirts")
// Style/occasion tags (e.g., "casual", "formal", "home", "work", "sport", "party")
  final List<String> _styles;
// Unit type (e.g., "pieces", "pairs", "t-shirts")
// Style/occasion tags (e.g., "casual", "formal", "home", "work", "sport", "party")
  @override
  @JsonKey()
  List<String> get styles {
    if (_styles is EqualUnmodifiableListView) return _styles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_styles);
  }

  @override
  String toString() {
    return 'DrawerItem(id: $id, category: $category, name: $name, location: $location, status: $status, lastOrganized: $lastOrganized, notes: $notes, currentQuantity: $currentQuantity, targetQuantity: $targetQuantity, unit: $unit, styles: $styles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrawerItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.lastOrganized, lastOrganized) ||
                other.lastOrganized == lastOrganized) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.currentQuantity, currentQuantity) ||
                other.currentQuantity == currentQuantity) &&
            (identical(other.targetQuantity, targetQuantity) ||
                other.targetQuantity == targetQuantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            const DeepCollectionEquality().equals(other._styles, _styles));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      category,
      name,
      location,
      status,
      lastOrganized,
      notes,
      currentQuantity,
      targetQuantity,
      unit,
      const DeepCollectionEquality().hash(_styles));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DrawerItemImplCopyWith<_$DrawerItemImpl> get copyWith =>
      __$$DrawerItemImplCopyWithImpl<_$DrawerItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DrawerItemImplToJson(
      this,
    );
  }
}

abstract class _DrawerItem implements DrawerItem {
  const factory _DrawerItem(
      {required final String id,
      final String category,
      required final String name,
      final String location,
      final DrawerStatus status,
      final DateTime? lastOrganized,
      final String? notes,
      final int currentQuantity,
      final int targetQuantity,
      final ItemUnit unit,
      final List<String> styles}) = _$DrawerItemImpl;

  factory _DrawerItem.fromJson(Map<String, dynamic> json) =
      _$DrawerItemImpl.fromJson;

  @override
  String get id;
  @override
  String get category;
  @override
  String get name;
  @override
  String get location;
  @override
  DrawerStatus get status;
  @override
  DateTime? get lastOrganized;
  @override
  String? get notes;
  @override // Quantity and unit tracking
  int get currentQuantity;
  @override // Current count (e.g., 3)
  int get targetQuantity;
  @override // Target count (e.g., 5)
  ItemUnit get unit;
  @override // Unit type (e.g., "pieces", "pairs", "t-shirts")
// Style/occasion tags (e.g., "casual", "formal", "home", "work", "sport", "party")
  List<String> get styles;
  @override
  @JsonKey(ignore: true)
  _$$DrawerItemImplCopyWith<_$DrawerItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
