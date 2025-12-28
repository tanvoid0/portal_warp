// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_prefs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserPrefs _$UserPrefsFromJson(Map<String, dynamic> json) {
  return _UserPrefs.fromJson(json);
}

/// @nodoc
mixin _$UserPrefs {
  Map<FocusArea, bool> get enabledFocusAreas =>
      throw _privateConstructorUsedError;
  Map<FocusArea, int> get priority => throw _privateConstructorUsedError; // 1-5
  Map<FocusArea, int> get weeklyTarget => throw _privateConstructorUsedError;
  int get timeBudgetMinutes =>
      throw _privateConstructorUsedError; // 10, 20, or 40
  int get difficultyCap => throw _privateConstructorUsedError; // 1-5
  EnergyLevel get defaultEnergy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPrefsCopyWith<UserPrefs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPrefsCopyWith<$Res> {
  factory $UserPrefsCopyWith(UserPrefs value, $Res Function(UserPrefs) then) =
      _$UserPrefsCopyWithImpl<$Res, UserPrefs>;
  @useResult
  $Res call(
      {Map<FocusArea, bool> enabledFocusAreas,
      Map<FocusArea, int> priority,
      Map<FocusArea, int> weeklyTarget,
      int timeBudgetMinutes,
      int difficultyCap,
      EnergyLevel defaultEnergy});
}

/// @nodoc
class _$UserPrefsCopyWithImpl<$Res, $Val extends UserPrefs>
    implements $UserPrefsCopyWith<$Res> {
  _$UserPrefsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabledFocusAreas = null,
    Object? priority = null,
    Object? weeklyTarget = null,
    Object? timeBudgetMinutes = null,
    Object? difficultyCap = null,
    Object? defaultEnergy = null,
  }) {
    return _then(_value.copyWith(
      enabledFocusAreas: null == enabledFocusAreas
          ? _value.enabledFocusAreas
          : enabledFocusAreas // ignore: cast_nullable_to_non_nullable
              as Map<FocusArea, bool>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Map<FocusArea, int>,
      weeklyTarget: null == weeklyTarget
          ? _value.weeklyTarget
          : weeklyTarget // ignore: cast_nullable_to_non_nullable
              as Map<FocusArea, int>,
      timeBudgetMinutes: null == timeBudgetMinutes
          ? _value.timeBudgetMinutes
          : timeBudgetMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      difficultyCap: null == difficultyCap
          ? _value.difficultyCap
          : difficultyCap // ignore: cast_nullable_to_non_nullable
              as int,
      defaultEnergy: null == defaultEnergy
          ? _value.defaultEnergy
          : defaultEnergy // ignore: cast_nullable_to_non_nullable
              as EnergyLevel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPrefsImplCopyWith<$Res>
    implements $UserPrefsCopyWith<$Res> {
  factory _$$UserPrefsImplCopyWith(
          _$UserPrefsImpl value, $Res Function(_$UserPrefsImpl) then) =
      __$$UserPrefsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<FocusArea, bool> enabledFocusAreas,
      Map<FocusArea, int> priority,
      Map<FocusArea, int> weeklyTarget,
      int timeBudgetMinutes,
      int difficultyCap,
      EnergyLevel defaultEnergy});
}

/// @nodoc
class __$$UserPrefsImplCopyWithImpl<$Res>
    extends _$UserPrefsCopyWithImpl<$Res, _$UserPrefsImpl>
    implements _$$UserPrefsImplCopyWith<$Res> {
  __$$UserPrefsImplCopyWithImpl(
      _$UserPrefsImpl _value, $Res Function(_$UserPrefsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabledFocusAreas = null,
    Object? priority = null,
    Object? weeklyTarget = null,
    Object? timeBudgetMinutes = null,
    Object? difficultyCap = null,
    Object? defaultEnergy = null,
  }) {
    return _then(_$UserPrefsImpl(
      enabledFocusAreas: null == enabledFocusAreas
          ? _value._enabledFocusAreas
          : enabledFocusAreas // ignore: cast_nullable_to_non_nullable
              as Map<FocusArea, bool>,
      priority: null == priority
          ? _value._priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Map<FocusArea, int>,
      weeklyTarget: null == weeklyTarget
          ? _value._weeklyTarget
          : weeklyTarget // ignore: cast_nullable_to_non_nullable
              as Map<FocusArea, int>,
      timeBudgetMinutes: null == timeBudgetMinutes
          ? _value.timeBudgetMinutes
          : timeBudgetMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      difficultyCap: null == difficultyCap
          ? _value.difficultyCap
          : difficultyCap // ignore: cast_nullable_to_non_nullable
              as int,
      defaultEnergy: null == defaultEnergy
          ? _value.defaultEnergy
          : defaultEnergy // ignore: cast_nullable_to_non_nullable
              as EnergyLevel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPrefsImpl implements _UserPrefs {
  const _$UserPrefsImpl(
      {final Map<FocusArea, bool> enabledFocusAreas = const {},
      final Map<FocusArea, int> priority = const {},
      final Map<FocusArea, int> weeklyTarget = const {},
      this.timeBudgetMinutes = 20,
      this.difficultyCap = 5,
      this.defaultEnergy = EnergyLevel.medium})
      : _enabledFocusAreas = enabledFocusAreas,
        _priority = priority,
        _weeklyTarget = weeklyTarget;

  factory _$UserPrefsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPrefsImplFromJson(json);

  final Map<FocusArea, bool> _enabledFocusAreas;
  @override
  @JsonKey()
  Map<FocusArea, bool> get enabledFocusAreas {
    if (_enabledFocusAreas is EqualUnmodifiableMapView)
      return _enabledFocusAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_enabledFocusAreas);
  }

  final Map<FocusArea, int> _priority;
  @override
  @JsonKey()
  Map<FocusArea, int> get priority {
    if (_priority is EqualUnmodifiableMapView) return _priority;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_priority);
  }

// 1-5
  final Map<FocusArea, int> _weeklyTarget;
// 1-5
  @override
  @JsonKey()
  Map<FocusArea, int> get weeklyTarget {
    if (_weeklyTarget is EqualUnmodifiableMapView) return _weeklyTarget;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_weeklyTarget);
  }

  @override
  @JsonKey()
  final int timeBudgetMinutes;
// 10, 20, or 40
  @override
  @JsonKey()
  final int difficultyCap;
// 1-5
  @override
  @JsonKey()
  final EnergyLevel defaultEnergy;

  @override
  String toString() {
    return 'UserPrefs(enabledFocusAreas: $enabledFocusAreas, priority: $priority, weeklyTarget: $weeklyTarget, timeBudgetMinutes: $timeBudgetMinutes, difficultyCap: $difficultyCap, defaultEnergy: $defaultEnergy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPrefsImpl &&
            const DeepCollectionEquality()
                .equals(other._enabledFocusAreas, _enabledFocusAreas) &&
            const DeepCollectionEquality().equals(other._priority, _priority) &&
            const DeepCollectionEquality()
                .equals(other._weeklyTarget, _weeklyTarget) &&
            (identical(other.timeBudgetMinutes, timeBudgetMinutes) ||
                other.timeBudgetMinutes == timeBudgetMinutes) &&
            (identical(other.difficultyCap, difficultyCap) ||
                other.difficultyCap == difficultyCap) &&
            (identical(other.defaultEnergy, defaultEnergy) ||
                other.defaultEnergy == defaultEnergy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_enabledFocusAreas),
      const DeepCollectionEquality().hash(_priority),
      const DeepCollectionEquality().hash(_weeklyTarget),
      timeBudgetMinutes,
      difficultyCap,
      defaultEnergy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPrefsImplCopyWith<_$UserPrefsImpl> get copyWith =>
      __$$UserPrefsImplCopyWithImpl<_$UserPrefsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPrefsImplToJson(
      this,
    );
  }
}

abstract class _UserPrefs implements UserPrefs {
  const factory _UserPrefs(
      {final Map<FocusArea, bool> enabledFocusAreas,
      final Map<FocusArea, int> priority,
      final Map<FocusArea, int> weeklyTarget,
      final int timeBudgetMinutes,
      final int difficultyCap,
      final EnergyLevel defaultEnergy}) = _$UserPrefsImpl;

  factory _UserPrefs.fromJson(Map<String, dynamic> json) =
      _$UserPrefsImpl.fromJson;

  @override
  Map<FocusArea, bool> get enabledFocusAreas;
  @override
  Map<FocusArea, int> get priority;
  @override // 1-5
  Map<FocusArea, int> get weeklyTarget;
  @override
  int get timeBudgetMinutes;
  @override // 10, 20, or 40
  int get difficultyCap;
  @override // 1-5
  EnergyLevel get defaultEnergy;
  @override
  @JsonKey(ignore: true)
  _$$UserPrefsImplCopyWith<_$UserPrefsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
