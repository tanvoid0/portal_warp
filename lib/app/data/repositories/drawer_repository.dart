import '../models/drawer_item.dart';
import '../local/json_storage.dart';

/// Repository for drawer items using JSON file storage
class DrawerRepository {
  static const String _filename = 'drawer_items.json';

  Future<List<DrawerItem>> _loadItems() async {
    final data = await JsonStorage.readList(_filename);
    return data.map((json) {
      if (json['lastOrganized'] != null && json['lastOrganized'] is String) {
        json['lastOrganized'] = DateTime.parse(json['lastOrganized']).toIso8601String();
      }
      return DrawerItem.fromJson(json);
    }).toList();
  }

  Future<void> _saveItems(List<DrawerItem> items) async {
    final data = items.map((i) {
      final json = i.toJson();
      if (i.lastOrganized != null) {
        json['lastOrganized'] = i.lastOrganized!.toIso8601String();
      }
      return json;
    }).toList();
    await JsonStorage.writeList(_filename, data);
  }

  Future<List<DrawerItem>> getDrawerItems() async {
    return await _loadItems();
  }

  Future<void> addDrawerItem(DrawerItem item) async {
    final items = await _loadItems();
    items.add(item);
    await _saveItems(items);
  }

  Future<void> updateDrawerItem(DrawerItem item) async {
    final items = await _loadItems();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      items[index] = item;
      await _saveItems(items);
    }
  }

  Future<void> deleteDrawerItem(String id) async {
    final items = await _loadItems();
    items.removeWhere((item) => item.id == id);
    await _saveItems(items);
  }

  Future<Map<String, dynamic>> getDrawerStatus() async {
    final items = await _loadItems();
    final total = items.length;
    final organized = items.where((item) => item.status.name == 'organized').length;
    final unorganized = total - organized;
    final percentage = total > 0 ? (organized / total).toDouble() : 0.0;
    final lastOrganized = items
        .where((item) => item.lastOrganized != null)
        .map((item) => item.lastOrganized!)
        .fold<DateTime?>(null, (prev, date) => prev == null || date.isAfter(prev) ? date : prev);

    return {
      'totalItems': total,
      'organized': organized,
      'unorganized': unorganized,
      'percentage': percentage,
      'lastOrganized': lastOrganized,
    };
  }
}
