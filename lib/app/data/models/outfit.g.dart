// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outfit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OutfitImpl _$$OutfitImplFromJson(Map<String, dynamic> json) => _$OutfitImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$OutfitTypeEnumMap, json['type']),
      top: json['top'] as String? ?? '',
      bottom: json['bottom'] as String? ?? '',
      shoes: json['shoes'] as String? ?? '',
      layer: json['layer'] as String? ?? '',
      accessories: json['accessories'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      lastWorn: json['lastWorn'] == null
          ? null
          : DateTime.parse(json['lastWorn'] as String),
      timesWorn: (json['timesWorn'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$OutfitImplToJson(_$OutfitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$OutfitTypeEnumMap[instance.type]!,
      'top': instance.top,
      'bottom': instance.bottom,
      'shoes': instance.shoes,
      'layer': instance.layer,
      'accessories': instance.accessories,
      'notes': instance.notes,
      'lastWorn': instance.lastWorn?.toIso8601String(),
      'timesWorn': instance.timesWorn,
    };

const _$OutfitTypeEnumMap = {
  OutfitType.casual: 'casual',
  OutfitType.professional: 'professional',
};
