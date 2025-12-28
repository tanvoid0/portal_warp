import '../models/plan_item.dart';
import '../local/json_storage.dart';

/// Repository for plan items using JSON file storage
class PlanRepository {
  static const String _filename = 'plan_items.json';

  Future<List<PlanItem>> _loadItems() async {
    final data = await JsonStorage.readList(_filename);
    return data.map((json) {
      if (json['date'] is String) {
        json['date'] = DateTime.parse(json['date']).toIso8601String();
      }
      return PlanItem.fromJson(json);
    }).toList();
  }

  Future<void> _saveItems(List<PlanItem> items) async {
    final data = items.map((i) {
      final json = i.toJson();
      json['date'] = i.date.toIso8601String();
      return json;
    }).toList();
    await JsonStorage.writeList(_filename, data);
  }

  Future<List<PlanItem>> getPlanItems() async {
    return await _loadItems();
  }

  Future<List<PlanItem>> getTodayPlans() async {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final items = await _loadItems();
    return items
        .where((item) =>
            item.date.isAfter(todayStart.subtract(const Duration(days: 1))) &&
            item.date.isBefore(todayEnd))
        .toList();
  }

  Future<void> addPlanItem(PlanItem item) async {
    final items = await _loadItems();
    items.add(item);
    await _saveItems(items);
  }

  Future<void> updatePlanItem(PlanItem item) async {
    final items = await _loadItems();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      items[index] = item;
      await _saveItems(items);
    }
  }

  Future<void> markCompleted(String id) async {
    final items = await _loadItems();
    final index = items.indexWhere((i) => i.id == id);
    if (index != -1) {
      final item = items[index];
      items[index] = item.copyWith(status: PlanStatus.completed);
      await _saveItems(items);
    }
  }

  Future<void> deletePlanItem(String id) async {
    final items = await _loadItems();
    items.removeWhere((item) => item.id == id);
    await _saveItems(items);
  }
}
