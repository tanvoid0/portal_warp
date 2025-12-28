import 'package:freezed_annotation/freezed_annotation.dart';
import 'item_unit.dart';

part 'plan_item.freezed.dart';
part 'plan_item.g.dart';

enum PlanStatus {
  pending,
  completed;

  String get displayName {
    switch (this) {
      case PlanStatus.pending:
        return 'Pending';
      case PlanStatus.completed:
        return 'Completed';
    }
  }
}

@freezed
class PlanItem with _$PlanItem {
  const factory PlanItem({
    required String id,
    required String title,
    required DateTime date,
    String? time,
    @Default('') String category,
    @Default(PlanStatus.pending) PlanStatus status,
    String? linkedQuestId,
    String? notes,
    // Quantity and unit tracking (for tasks like "Walk 10 minutes", "Do 3 sets")
    @Default(0) int quantity, // Quantity (e.g., 10 for "10 minutes", 3 for "3 sets")
    @Default(ItemUnit()) ItemUnit unit, // Unit type (e.g., "minutes", "sets", "reps")
  }) = _PlanItem;

  factory PlanItem.fromJson(Map<String, dynamic> json) =>
      _$PlanItemFromJson(json);
}

