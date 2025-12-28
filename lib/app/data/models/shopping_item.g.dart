// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingItemImpl _$$ShoppingItemImplFromJson(Map<String, dynamic> json) =>
    _$ShoppingItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      status: $enumDecodeNullable(_$ShoppingStatusEnumMap, json['status']) ??
          ShoppingStatus.pending,
      linkedQuestId: json['linkedQuestId'] as String?,
      unit: json['unit'] == null
          ? const ItemUnit()
          : ItemUnit.fromJson(json['unit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ShoppingItemImplToJson(_$ShoppingItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'quantity': instance.quantity,
      'priority': instance.priority,
      'status': _$ShoppingStatusEnumMap[instance.status]!,
      'linkedQuestId': instance.linkedQuestId,
      'unit': instance.unit,
    };

const _$ShoppingStatusEnumMap = {
  ShoppingStatus.pending: 'pending',
  ShoppingStatus.purchased: 'purchased',
};
