// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeklyReviewImpl _$$WeeklyReviewImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyReviewImpl(
      weekStart: DateTime.parse(json['weekStart'] as String),
      completionStats: (json['completionStats'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                $enumDecode(_$FocusAreaEnumMap, k), (e as num).toDouble()),
          ) ??
          const {},
      avoidedAreas: (json['avoidedAreas'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$FocusAreaEnumMap, e))
              .toList() ??
          const [],
      oneAdjustment: json['oneAdjustment'] as String?,
    );

Map<String, dynamic> _$$WeeklyReviewImplToJson(_$WeeklyReviewImpl instance) =>
    <String, dynamic>{
      'weekStart': instance.weekStart.toIso8601String(),
      'completionStats': instance.completionStats
          .map((k, e) => MapEntry(_$FocusAreaEnumMap[k]!, e)),
      'avoidedAreas':
          instance.avoidedAreas.map((e) => _$FocusAreaEnumMap[e]!).toList(),
      'oneAdjustment': instance.oneAdjustment,
    };

const _$FocusAreaEnumMap = {
  FocusArea.clothes: 'clothes',
  FocusArea.skincare: 'skincare',
  FocusArea.fitness: 'fitness',
  FocusArea.cooking: 'cooking',
};
