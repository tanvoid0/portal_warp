// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeeklyReview _$WeeklyReviewFromJson(Map<String, dynamic> json) {
  return _WeeklyReview.fromJson(json);
}

/// @nodoc
mixin _$WeeklyReview {
  DateTime get weekStart => throw _privateConstructorUsedError;
  Map<FocusArea, double> get completionStats =>
      throw _privateConstructorUsedError; // 0.0 to 1.0
  List<FocusArea> get avoidedAreas => throw _privateConstructorUsedError;
  String? get oneAdjustment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeeklyReviewCopyWith<WeeklyReview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyReviewCopyWith<$Res> {
  factory $WeeklyReviewCopyWith(
          WeeklyReview value, $Res Function(WeeklyReview) then) =
      _$WeeklyReviewCopyWithImpl<$Res, WeeklyReview>;
  @useResult
  $Res call(
      {DateTime weekStart,
      Map<FocusArea, double> completionStats,
      List<FocusArea> avoidedAreas,
      String? oneAdjustment});
}

/// @nodoc
class _$WeeklyReviewCopyWithImpl<$Res, $Val extends WeeklyReview>
    implements $WeeklyReviewCopyWith<$Res> {
  _$WeeklyReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? completionStats = null,
    Object? avoidedAreas = null,
    Object? oneAdjustment = freezed,
  }) {
    return _then(_value.copyWith(
      weekStart: null == weekStart
          ? _value.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completionStats: null == completionStats
          ? _value.completionStats
          : completionStats // ignore: cast_nullable_to_non_nullable
              as Map<FocusArea, double>,
      avoidedAreas: null == avoidedAreas
          ? _value.avoidedAreas
          : avoidedAreas // ignore: cast_nullable_to_non_nullable
              as List<FocusArea>,
      oneAdjustment: freezed == oneAdjustment
          ? _value.oneAdjustment
          : oneAdjustment // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyReviewImplCopyWith<$Res>
    implements $WeeklyReviewCopyWith<$Res> {
  factory _$$WeeklyReviewImplCopyWith(
          _$WeeklyReviewImpl value, $Res Function(_$WeeklyReviewImpl) then) =
      __$$WeeklyReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime weekStart,
      Map<FocusArea, double> completionStats,
      List<FocusArea> avoidedAreas,
      String? oneAdjustment});
}

/// @nodoc
class __$$WeeklyReviewImplCopyWithImpl<$Res>
    extends _$WeeklyReviewCopyWithImpl<$Res, _$WeeklyReviewImpl>
    implements _$$WeeklyReviewImplCopyWith<$Res> {
  __$$WeeklyReviewImplCopyWithImpl(
      _$WeeklyReviewImpl _value, $Res Function(_$WeeklyReviewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekStart = null,
    Object? completionStats = null,
    Object? avoidedAreas = null,
    Object? oneAdjustment = freezed,
  }) {
    return _then(_$WeeklyReviewImpl(
      weekStart: null == weekStart
          ? _value.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completionStats: null == completionStats
          ? _value._completionStats
          : completionStats // ignore: cast_nullable_to_non_nullable
              as Map<FocusArea, double>,
      avoidedAreas: null == avoidedAreas
          ? _value._avoidedAreas
          : avoidedAreas // ignore: cast_nullable_to_non_nullable
              as List<FocusArea>,
      oneAdjustment: freezed == oneAdjustment
          ? _value.oneAdjustment
          : oneAdjustment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyReviewImpl implements _WeeklyReview {
  const _$WeeklyReviewImpl(
      {required this.weekStart,
      final Map<FocusArea, double> completionStats = const {},
      final List<FocusArea> avoidedAreas = const [],
      this.oneAdjustment})
      : _completionStats = completionStats,
        _avoidedAreas = avoidedAreas;

  factory _$WeeklyReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyReviewImplFromJson(json);

  @override
  final DateTime weekStart;
  final Map<FocusArea, double> _completionStats;
  @override
  @JsonKey()
  Map<FocusArea, double> get completionStats {
    if (_completionStats is EqualUnmodifiableMapView) return _completionStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_completionStats);
  }

// 0.0 to 1.0
  final List<FocusArea> _avoidedAreas;
// 0.0 to 1.0
  @override
  @JsonKey()
  List<FocusArea> get avoidedAreas {
    if (_avoidedAreas is EqualUnmodifiableListView) return _avoidedAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_avoidedAreas);
  }

  @override
  final String? oneAdjustment;

  @override
  String toString() {
    return 'WeeklyReview(weekStart: $weekStart, completionStats: $completionStats, avoidedAreas: $avoidedAreas, oneAdjustment: $oneAdjustment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyReviewImpl &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            const DeepCollectionEquality()
                .equals(other._completionStats, _completionStats) &&
            const DeepCollectionEquality()
                .equals(other._avoidedAreas, _avoidedAreas) &&
            (identical(other.oneAdjustment, oneAdjustment) ||
                other.oneAdjustment == oneAdjustment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      weekStart,
      const DeepCollectionEquality().hash(_completionStats),
      const DeepCollectionEquality().hash(_avoidedAreas),
      oneAdjustment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyReviewImplCopyWith<_$WeeklyReviewImpl> get copyWith =>
      __$$WeeklyReviewImplCopyWithImpl<_$WeeklyReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyReviewImplToJson(
      this,
    );
  }
}

abstract class _WeeklyReview implements WeeklyReview {
  const factory _WeeklyReview(
      {required final DateTime weekStart,
      final Map<FocusArea, double> completionStats,
      final List<FocusArea> avoidedAreas,
      final String? oneAdjustment}) = _$WeeklyReviewImpl;

  factory _WeeklyReview.fromJson(Map<String, dynamic> json) =
      _$WeeklyReviewImpl.fromJson;

  @override
  DateTime get weekStart;
  @override
  Map<FocusArea, double> get completionStats;
  @override // 0.0 to 1.0
  List<FocusArea> get avoidedAreas;
  @override
  String? get oneAdjustment;
  @override
  @JsonKey(ignore: true)
  _$$WeeklyReviewImplCopyWith<_$WeeklyReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
