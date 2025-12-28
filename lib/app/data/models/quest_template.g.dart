// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestTemplateImpl _$$QuestTemplateImplFromJson(Map<String, dynamic> json) =>
    _$QuestTemplateImpl(
      id: json['id'] as String,
      focusAreaId: $enumDecode(_$FocusAreaEnumMap, json['focusAreaId']),
      title: json['title'] as String,
      durationBucket: (json['durationBucket'] as num?)?.toInt() ?? 10,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 3,
      cooldownDays: (json['cooldownDays'] as num?)?.toInt() ?? 0,
      instructions: json['instructions'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$QuestTemplateImplToJson(_$QuestTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'focusAreaId': _$FocusAreaEnumMap[instance.focusAreaId]!,
      'title': instance.title,
      'durationBucket': instance.durationBucket,
      'difficulty': instance.difficulty,
      'cooldownDays': instance.cooldownDays,
      'instructions': instance.instructions,
      'tags': instance.tags,
    };

const _$FocusAreaEnumMap = {
  FocusArea.clothes: 'clothes',
  FocusArea.skincare: 'skincare',
  FocusArea.fitness: 'fitness',
  FocusArea.cooking: 'cooking',
};
