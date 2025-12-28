// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestInstanceImpl _$$QuestInstanceImplFromJson(Map<String, dynamic> json) =>
    _$QuestInstanceImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      templateId: json['templateId'] as String,
      status: $enumDecodeNullable(_$QuestStatusEnumMap, json['status']) ??
          QuestStatus.todo,
      xpAwarded: (json['xpAwarded'] as num?)?.toInt() ?? 0,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$QuestInstanceImplToJson(_$QuestInstanceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'templateId': instance.templateId,
      'status': _$QuestStatusEnumMap[instance.status]!,
      'xpAwarded': instance.xpAwarded,
      'note': instance.note,
    };

const _$QuestStatusEnumMap = {
  QuestStatus.todo: 'todo',
  QuestStatus.done: 'done',
  QuestStatus.skip: 'skip',
};
