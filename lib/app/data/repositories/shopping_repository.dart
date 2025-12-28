import '../models/shopping_item.dart';
import '../local/json_storage.dart';

/// Repository for shopping items using JSON file storage
class ShoppingRepository {
  static const String _filename = 'shopping_items.json';

  Future<List<ShoppingItem>> _loadItems() async {
    final data = await JsonStorage.readList(_filename);
    return data.map((json) => ShoppingItem.fromJson(json)).toList();
  }

  Future<void> _saveItems(List<ShoppingItem> items) async {
    final data = items.map((i) => i.toJson()).toList();
    await JsonStorage.writeList(_filename, data);
  }

  Future<List<ShoppingItem>> getShoppingItems() async {
    return await _loadItems();
  }

  Future<List<ShoppingItem>> getPendingItems() async {
    final items = await _loadItems();
    return items
        .where((item) => item.status.name == 'pending')
        .toList();
  }

  Future<void> addShoppingItem(ShoppingItem item) async {
    final items = await _loadItems();
    items.add(item);
    await _saveItems(items);
  }

  Future<void> updateShoppingItem(ShoppingItem item) async {
    final items = await _loadItems();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      items[index] = item;
      await _saveItems(items);
    }
  }

  Future<void> markPurchased(String id) async {
    final items = await _loadItems();
    final index = items.indexWhere((i) => i.id == id);
    if (index != -1) {
      final item = items[index];
      items[index] = item.copyWith(status: ShoppingStatus.purchased);
      await _saveItems(items);
    }
  }

  Future<void> deleteShoppingItem(String id) async {
    final items = await _loadItems();
    items.removeWhere((item) => item.id == id);
    await _saveItems(items);
  }
}
