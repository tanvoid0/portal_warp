// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlanItemImpl _$$PlanItemImplFromJson(Map<String, dynamic> json) =>
    _$PlanItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String?,
      category: json['category'] as String? ?? '',
      status: $enumDecodeNullable(_$PlanStatusEnumMap, json['status']) ??
          PlanStatus.pending,
      linkedQuestId: json['linkedQuestId'] as String?,
      notes: json['notes'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unit: json['unit'] == null
          ? const ItemUnit()
          : ItemUnit.fromJson(json['unit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PlanItemImplToJson(_$PlanItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'category': instance.category,
      'status': _$PlanStatusEnumMap[instance.status]!,
      'linkedQuestId': instance.linkedQuestId,
      'notes': instance.notes,
      'quantity': instance.quantity,
      'unit': instance.unit,
    };

const _$PlanStatusEnumMap = {
  PlanStatus.pending: 'pending',
  PlanStatus.completed: 'completed',
};
