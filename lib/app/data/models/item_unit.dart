import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_unit.freezed.dart';
part 'item_unit.g.dart';

/// Common units for different item types
enum UnitType {
  // Clothing
  pieces,
  pairs,
  items,
  
  // Shopping
  kg,
  grams,
  liters,
  milliliters,
  bottles,
  cans,
  boxes,
  packs,
  bags,
  
  // General
  count,
  custom;

  String get displayName {
    switch (this) {
      case UnitType.pieces:
        return 'pieces';
      case UnitType.pairs:
        return 'pairs';
      case UnitType.items:
        return 'items';
      case UnitType.kg:
        return 'kg';
      case UnitType.grams:
        return 'grams';
      case UnitType.liters:
        return 'liters';
      case UnitType.milliliters:
        return 'ml';
      case UnitType.bottles:
        return 'bottles';
      case UnitType.cans:
        return 'cans';
      case UnitType.boxes:
        return 'boxes';
      case UnitType.packs:
        return 'packs';
      case UnitType.bags:
        return 'bags';
      case UnitType.count:
        return 'count';
      case UnitType.custom:
        return 'custom';
    }
  }

  static List<UnitType> get clothingUnits => [pieces, pairs, items];
  static List<UnitType> get shoppingUnits => [kg, grams, liters, milliliters, bottles, cans, boxes, packs, bags, count];
  static List<UnitType> get generalUnits => [count, items, pieces];
}

@freezed
class ItemUnit with _$ItemUnit {
  const ItemUnit._(); // Private constructor for custom methods
  
  const factory ItemUnit({
    @Default(UnitType.count) UnitType type,
    @Default('') String customUnit, // For custom units like "t-shirts", "shirts", etc.
  }) = _ItemUnit;

  factory ItemUnit.fromJson(Map<String, dynamic> json) => _$ItemUnitFromJson(json);

  String get displayName {
    if (type == UnitType.custom && customUnit.isNotEmpty) {
      return customUnit;
    }
    return type.displayName;
  }
}
