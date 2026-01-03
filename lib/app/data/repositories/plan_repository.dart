import 'package:get/get.dart';
import '../models/plan_item.dart';
import '../models/item_unit.dart';
import '../local/json_storage.dart';
import '../../core/services/api_client.dart';

/// Repository for plan items with hybrid sync (API + local cache)
class PlanRepository {
  static const String _cacheFilename = 'plan_items_cache.json';
  
  ApiClient? get _apiClient {
    try {
      return Get.find<ApiClient>();
    } catch (_) {
      return null;
    }
  }
  
  // ============ Cache Methods ============
  
  Future<List<PlanItem>> _loadFromCache() async {
    try {
      final data = await JsonStorage.readList(_cacheFilename);
      return data.map((json) {
        try {
          if (json['date'] is String) {
            json['date'] = DateTime.parse(json['date']).toIso8601String();
          }
          return PlanItem.fromJson(json);
        } catch (e) {
          return null;
        }
      }).whereType<PlanItem>().toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveToCache(List<PlanItem> items) async {
    try {
      final data = items.map((i) {
        final json = i.toJson();
        json['date'] = i.date.toIso8601String();
        return json;
      }).toList();
      await JsonStorage.writeList(_cacheFilename, data);
    } catch (e) {
      // Cache save failed, ignore
    }
  }
  
  // ============ API Methods ============
  
  Future<List<PlanItem>> getPlanItems() async {
    final api = _apiClient;
    if (api == null) return _loadFromCache();
    
    try {
      final response = await api.get('/plans');
      final items = (response as List)
          .map((json) => _mapApiToPlanItem(json))
          .toList();
      
      // Cache the response
      await _saveToCache(items);
      return items;
    } on ApiException {
      rethrow;
    } catch (e) {
      // Fallback to cache on network error
      return _loadFromCache();
    }
  }

  Future<List<PlanItem>> getTodayPlans() async {
    final api = _apiClient;
    if (api == null) {
      // Fallback to local filtering
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = todayStart.add(const Duration(days: 1));
      final items = await _loadFromCache();
      return items
          .where((item) =>
              item.date.isAfter(todayStart.subtract(const Duration(days: 1))) &&
              item.date.isBefore(todayEnd))
          .toList();
    }
    
    try {
      final response = await api.get('/plans/today');
      return (response as List)
          .map((json) => _mapApiToPlanItem(json))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      // Fallback to cache
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = todayStart.add(const Duration(days: 1));
      final items = await _loadFromCache();
      return items
          .where((item) =>
              item.date.isAfter(todayStart.subtract(const Duration(days: 1))) &&
              item.date.isBefore(todayEnd))
          .toList();
    }
  }

  Future<void> addPlanItem(PlanItem item) async {
    final api = _apiClient;
    if (api == null) {
      // Offline mode - save to cache only
      final items = await _loadFromCache();
      items.add(item);
      await _saveToCache(items);
      return;
    }
    
    await api.post('/plans', body: _mapPlanItemToApi(item));
  }

  Future<void> updatePlanItem(PlanItem item) async {
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
    
    await api.put('/plans/${item.id}', body: _mapPlanItemToApi(item));
  }

  Future<void> markCompleted(String id) async {
    final api = _apiClient;
    if (api == null) {
      final items = await _loadFromCache();
      final index = items.indexWhere((i) => i.id == id);
      if (index != -1) {
        items[index] = items[index].copyWith(status: PlanStatus.completed);
        await _saveToCache(items);
      }
      return;
    }
    
    await api.patch('/plans/$id/complete');
  }

  Future<void> deletePlanItem(String id) async {
    final api = _apiClient;
    if (api == null) {
      final items = await _loadFromCache();
      items.removeWhere((item) => item.id == id);
      await _saveToCache(items);
      return;
    }
    
    await api.delete('/plans/$id');
  }
  
  // ============ Mapping Helpers ============
  
  PlanItem _mapApiToPlanItem(Map<String, dynamic> json) {
    return PlanItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: DateTime.parse(json['date']),
      time: json['time'],
      category: json['category'] ?? '',
      status: json['status'] == 'completed' 
          ? PlanStatus.completed 
          : PlanStatus.pending,
      linkedQuestId: json['linked_quest_id'],
      notes: json['notes'],
      quantity: json['quantity'] ?? 0,
      unit: json['unit'] != null 
          ? _mapUnitFromApi(json['unit']) 
          : const ItemUnit(),
    );
  }
  
  Map<String, dynamic> _mapPlanItemToApi(PlanItem item) {
    return {
      'title': item.title,
      'date': item.date.toUtc().toIso8601String(),
      'time': item.time,
      'category': item.category,
      'status': item.status.name,
      'linked_quest_id': item.linkedQuestId,
      'notes': item.notes,
      'quantity': item.quantity,
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
