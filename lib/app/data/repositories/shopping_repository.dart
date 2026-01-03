import 'package:get/get.dart';
import '../models/shopping_item.dart';
import '../models/item_unit.dart';
import '../local/json_storage.dart';
import '../../core/services/api_client.dart';

/// Repository for shopping items with hybrid sync (API + local cache)
class ShoppingRepository {
  static const String _cacheFilename = 'shopping_items_cache.json';
  
  ApiClient? get _apiClient {
    try {
      return Get.find<ApiClient>();
    } catch (_) {
      return null;
    }
  }

  // ============ Cache Methods ============

  Future<List<ShoppingItem>> _loadFromCache() async {
    try {
      final data = await JsonStorage.readList(_cacheFilename);
      return data.map((json) {
        try {
          return ShoppingItem.fromJson(json);
        } catch (e) {
          return null;
        }
      }).whereType<ShoppingItem>().toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveToCache(List<ShoppingItem> items) async {
    try {
      final data = items.map((i) => i.toJson()).toList();
      await JsonStorage.writeList(_cacheFilename, data);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // ============ API Methods ============

  Future<List<ShoppingItem>> getShoppingItems() async {
    final api = _apiClient;
    if (api == null) return _loadFromCache();
    
    try {
      final response = await api.get('/shopping');
      final items = (response as List)
          .map((json) => _mapApiToShoppingItem(json))
          .toList();
      await _saveToCache(items);
      return items;
    } on ApiException {
      rethrow;
    } catch (e) {
      return _loadFromCache();
    }
  }

  Future<List<ShoppingItem>> getPendingItems() async {
    final api = _apiClient;
    if (api == null) {
      final items = await _loadFromCache();
      return items.where((item) => item.status == ShoppingStatus.pending).toList();
    }
    
    try {
      final response = await api.get('/shopping/pending');
      return (response as List)
          .map((json) => _mapApiToShoppingItem(json))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      final items = await _loadFromCache();
      return items.where((item) => item.status == ShoppingStatus.pending).toList();
    }
  }

  Future<void> addShoppingItem(ShoppingItem item) async {
    final api = _apiClient;
    if (api == null) {
      final items = await _loadFromCache();
      items.add(item);
      await _saveToCache(items);
      return;
    }
    
    await api.post('/shopping', body: _mapShoppingItemToApi(item));
  }

  Future<void> updateShoppingItem(ShoppingItem item) async {
    final api = _apiClient;
    if (api == null) {
      final items = await _loadFromCache();
      final index = items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        items[index] = item;
        await _saveToCache(items);
      }
      return;
    }
    
    await api.put('/shopping/${item.id}', body: _mapShoppingItemToApi(item));
  }

  Future<void> markPurchased(String id) async {
    final api = _apiClient;
    if (api == null) {
      final items = await _loadFromCache();
      final index = items.indexWhere((i) => i.id == id);
      if (index != -1) {
        items[index] = items[index].copyWith(status: ShoppingStatus.purchased);
        await _saveToCache(items);
      }
      return;
    }
    
    await api.patch('/shopping/$id/purchase');
  }

  Future<void> deleteShoppingItem(String id) async {
    final api = _apiClient;
    if (api == null) {
      final items = await _loadFromCache();
      items.removeWhere((item) => item.id == id);
      await _saveToCache(items);
      return;
    }
    
    await api.delete('/shopping/$id');
  }
  
  // ============ Mapping Helpers ============
  
  ShoppingItem _mapApiToShoppingItem(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      quantity: json['quantity'] ?? 1,
      priority: json['priority'] ?? 1,
      status: json['status'] == 'purchased' 
          ? ShoppingStatus.purchased 
          : ShoppingStatus.pending,
      linkedQuestId: json['linked_quest_id'],
      unit: json['unit'] != null 
          ? _mapUnitFromApi(json['unit']) 
          : const ItemUnit(),
    );
  }
  
  Map<String, dynamic> _mapShoppingItemToApi(ShoppingItem item) {
    return {
      'name': item.name,
      'category': item.category,
      'quantity': item.quantity,
      'priority': item.priority,
      'status': item.status.name,
      'linked_quest_id': item.linkedQuestId,
      'unit': {
        'type': item.unit.type.name,
        'custom_unit': item.unit.customUnit,
      },
    };
  }
  
  ItemUnit _mapUnitFromApi(Map<String, dynamic> json) {
    final typeStr = json['type'] ?? 'count';
    return ItemUnit(
      type: UnitType.values.firstWhere(
        (e) => e.name == typeStr,
        orElse: () => UnitType.count,
      ),
      customUnit: json['custom_unit'] ?? '',
    );
  }
}
