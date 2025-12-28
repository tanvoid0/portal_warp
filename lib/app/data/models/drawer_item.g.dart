// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawer_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DrawerItemImpl _$$DrawerItemImplFromJson(Map<String, dynamic> json) =>
    _$DrawerItemImpl(
      id: json['id'] as String,
      category: json['category'] as String? ?? '',
      name: json['name'] as String,
      location: json['location'] as String? ?? '',
      status: $enumDecodeNullable(_$DrawerStatusEnumMap, json['status']) ??
          DrawerStatus.unorganized,
      lastOrganized: json['lastOrganized'] == null
          ? null
          : DateTime.parse(json['lastOrganized'] as String),
      notes: json['notes'] as String?,
      currentQuantity: (json['currentQuantity'] as num?)?.toInt() ?? 0,
      targetQuantity: (json['targetQuantity'] as num?)?.toInt() ?? 0,
      unit: json['unit'] == null
          ? const ItemUnit()
          : ItemUnit.fromJson(json['unit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DrawerItemImplToJson(_$DrawerItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'name': instance.name,
      'location': instance.location,
      'status': _$DrawerStatusEnumMap[instance.status]!,
      'lastOrganized': instance.lastOrganized?.toIso8601String(),
      'notes': instance.notes,
      'currentQuantity': instance.currentQuantity,
      'targetQuantity': instance.targetQuantity,
      'unit': instance.unit,
    };

const _$DrawerStatusEnumMap = {
  DrawerStatus.organized: 'organized',
  DrawerStatus.unorganized: 'unorganized',
};
