import 'package:freezed_annotation/freezed_annotation.dart';
import 'item_unit.dart';

part 'drawer_item.freezed.dart';
part 'drawer_item.g.dart';

enum DrawerStatus {
  organized,
  unorganized;

  String get displayName {
    switch (this) {
      case DrawerStatus.organized:
        return 'Organized';
      case DrawerStatus.unorganized:
        return 'Unorganized';
    }
  }
}

@freezed
class DrawerItem with _$DrawerItem {
  const factory DrawerItem({
    required String id,
    @Default('') String category,
    required String name,
    @Default('') String location,
    @Default(DrawerStatus.unorganized) DrawerStatus status,
    DateTime? lastOrganized,
    String? notes,
    // Quantity and unit tracking
    @Default(0) int currentQuantity, // Current count (e.g., 3)
    @Default(0) int targetQuantity, // Target count (e.g., 5)
    @Default(ItemUnit()) ItemUnit unit, // Unit type (e.g., "pieces", "pairs", "t-shirts")
  }) = _DrawerItem;

  factory DrawerItem.fromJson(Map<String, dynamic> json) =>
      _$DrawerItemFromJson(json);
}

