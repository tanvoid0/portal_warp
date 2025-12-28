import 'package:freezed_annotation/freezed_annotation.dart';
import 'item_unit.dart';

part 'shopping_item.freezed.dart';
part 'shopping_item.g.dart';

enum ShoppingStatus {
  pending,
  purchased;

  String get displayName {
    switch (this) {
      case ShoppingStatus.pending:
        return 'Pending';
      case ShoppingStatus.purchased:
        return 'Purchased';
    }
  }
}

@freezed
class ShoppingItem with _$ShoppingItem {
  const factory ShoppingItem({
    required String id,
    required String name,
    @Default('') String category,
    @Default(1) int quantity,
    @Default(1) int priority, // 1-5
    @Default(ShoppingStatus.pending) ShoppingStatus status,
    String? linkedQuestId,
    // Unit tracking
    @Default(ItemUnit()) ItemUnit unit, // Unit type (e.g., "kg", "bottles", "packs")
  }) = _ShoppingItem;

  factory ShoppingItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemFromJson(json);
}

