// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_prefs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPrefsImpl _$$UserPrefsImplFromJson(Map<String, dynamic> json) =>
    _$UserPrefsImpl(
      enabledFocusAreas:
          (json['enabledFocusAreas'] as Map<String, dynamic>?)?.map(
                (k, e) =>
                    MapEntry($enumDecode(_$FocusAreaEnumMap, k), e as bool),
              ) ??
              const {},
      priority: (json['priority'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                $enumDecode(_$FocusAreaEnumMap, k), (e as num).toInt()),
          ) ??
          const {},
      weeklyTarget: (json['weeklyTarget'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                $enumDecode(_$FocusAreaEnumMap, k), (e as num).toInt()),
          ) ??
          const {},
      timeBudgetMinutes: (json['timeBudgetMinutes'] as num?)?.toInt() ?? 20,
      difficultyCap: (json['difficultyCap'] as num?)?.toInt() ?? 5,
      defaultEnergy:
          $enumDecodeNullable(_$EnergyLevelEnumMap, json['defaultEnergy']) ??
              EnergyLevel.medium,
    );

Map<String, dynamic> _$$UserPrefsImplToJson(_$UserPrefsImpl instance) =>
    <String, dynamic>{
      'enabledFocusAreas': instance.enabledFocusAreas
          .map((k, e) => MapEntry(_$FocusAreaEnumMap[k]!, e)),
      'priority':
          instance.priority.map((k, e) => MapEntry(_$FocusAreaEnumMap[k]!, e)),
      'weeklyTarget': instance.weeklyTarget
          .map((k, e) => MapEntry(_$FocusAreaEnumMap[k]!, e)),
      'timeBudgetMinutes': instance.timeBudgetMinutes,
      'difficultyCap': instance.difficultyCap,
      'defaultEnergy': _$EnergyLevelEnumMap[instance.defaultEnergy]!,
    };

const _$FocusAreaEnumMap = {
  FocusArea.clothes: 'clothes',
  FocusArea.skincare: 'skincare',
  FocusArea.fitness: 'fitness',
  FocusArea.cooking: 'cooking',
};

const _$EnergyLevelEnumMap = {
  EnergyLevel.low: 'low',
  EnergyLevel.medium: 'medium',
  EnergyLevel.high: 'high',
};
