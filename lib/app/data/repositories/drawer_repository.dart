import 'package:get/get.dart';
import '../models/drawer_item.dart';
import '../models/item_unit.dart';
import '../local/json_storage.dart';
import '../../core/services/api_client.dart';

/// Repository for drawer items with hybrid sync (API + local cache)
class DrawerRepository {
  static const String _cacheFilename = 'drawer_items_cache.json';
  
  ApiClient? get _apiClient {
    try {
      return Get.find<ApiClient>();
    } catch (_) {
      return null;
    }
  }

  // ============ Cache Methods ============

  Future<List<DrawerItem>> _loadFromCache() async {
    try {
      final data = await JsonStorage.readList(_cacheFilename);
      return data.map((json) {
        try {
          if (json['lastOrganized'] != null && json['lastOrganized'] is String) {
            json['lastOrganized'] = DateTime.parse(json['lastOrganized']).toIso8601String();
          }
          return DrawerItem.fromJson(json);
        } catch (e) {
          return null;
        }
      }).whereType<DrawerItem>().toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveToCache(List<DrawerItem> items) async {
    try {
      final data = items.map((i) {
        final json = i.toJson();
        if (i.lastOrganized != null) {
          json['lastOrganized'] = i.lastOrganized!.toIso8601String();
        }
        return json;
      }).toList();
      await JsonStorage.writeList(_cacheFilename, data);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // ============ API Methods ============

  Future<List<DrawerItem>> getDrawerItems() async {
    final api = _apiClient;
    if (api == null) return _loadFromCache();
    
    try {
      final response = await api.get('/drawer');
      final items = (response as List)
          .map((json) => _mapApiToDrawerItem(json))
          .toList();
      await _saveToCache(items);
      return items;
    } on ApiException {
      rethrow;
    } catch (e) {
      return _loadFromCache();
    }
  }

  Future<void> addDrawerItem(DrawerItem item) async {
    final api = _apiClient;
    if (api == null) {
      final items = await _loadFromCache();
      items.add(item);
      await _saveToCache(items);
      return;
    }
    
    await api.post('/drawer', body: _mapDrawerItemToApi(item));
  }

  Future<void> updateDrawerItem(DrawerItem item) async {
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
    
    await api.put('/drawer/${item.id}', body: _mapDrawerItemToApi(item));
  }

  Future<void> deleteDrawerItem(String id) async {
    final api = _apiClient;
    if (api == null) {
      final items = await _loadFromCache();
      items.removeWhere((item) => item.id == id);
      await _saveToCache(items);
      return;
    }
    
    await api.delete('/drawer/$id');
  }

  Future<Map<String, dynamic>> getDrawerStatus() async {
    final api = _apiClient;
    
    if (api != null) {
      try {
        final response = await api.get('/drawer/status');
        return {
          'totalItems': response['total_items'] ?? 0,
          'organized': response['organized'] ?? 0,
          'unorganized': response['unorganized'] ?? 0,
          'percentage': response['percentage'] ?? 0.0,
          'lastOrganized': response['last_organized'] != null 
              ? DateTime.parse(response['last_organized']) 
              : null,
        };
      } catch (e) {
        // Fall through to local calculation
      }
    }
    
    // Calculate locally
    final items = await _loadFromCache();
    final total = items.length;
    final organized = items.where((item) => item.status == DrawerStatus.organized).length;
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
  
  // ============ Mapping Helpers ============
  
  DrawerItem _mapApiToDrawerItem(Map<String, dynamic> json) {
    return DrawerItem(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] == 'organized' 
          ? DrawerStatus.organized 
          : DrawerStatus.unorganized,
      lastOrganized: json['last_organized'] != null 
          ? DateTime.parse(json['last_organized']) 
          : null,
      notes: json['notes'],
      currentQuantity: json['current_quantity'] ?? 0,
      targetQuantity: json['target_quantity'] ?? 0,
      unit: json['unit'] != null 
          ? _mapUnitFromApi(json['unit']) 
          : const ItemUnit(),
      styles: (json['styles'] as List?)?.cast<String>() ?? [],
    );
  }
  
  Map<String, dynamic> _mapDrawerItemToApi(DrawerItem item) {
    return {
      'name': item.name,
      'category': item.category,
      'location': item.location,
      'status': item.status.name,
      'notes': item.notes,
      'current_quantity': item.currentQuantity,
      'target_quantity': item.targetQuantity,
      'unit': {
        'type': item.unit.type.name,
        'custom_unit': item.unit.customUnit,
      },
      'styles': item.styles,
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
