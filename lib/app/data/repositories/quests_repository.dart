import 'package:get/get.dart';
import '../models/quest_instance.dart';
import '../local/json_storage.dart';
import '../../core/services/api_client.dart';

/// Repository for quest instances with hybrid sync (API + local cache)
class QuestsRepository {
  static const String _cacheFilename = 'quest_instances_cache.json';
  
  ApiClient? get _apiClient {
    try {
      return Get.find<ApiClient>();
    } catch (_) {
      return null;
    }
  }

  // ============ Cache Methods ============

  Future<List<QuestInstance>> _loadFromCache() async {
    try {
      final data = await JsonStorage.readList(_cacheFilename);
      return data.map((json) {
        try {
          if (json['date'] is String) {
            json['date'] = DateTime.parse(json['date']).toIso8601String();
          }
          return QuestInstance.fromJson(json);
        } catch (e) {
          return null;
        }
      }).whereType<QuestInstance>().toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveToCache(List<QuestInstance> instances) async {
    try {
      final data = instances.map((i) {
        final json = i.toJson();
        json['date'] = i.date.toIso8601String();
        return json;
      }).toList();
      await JsonStorage.writeList(_cacheFilename, data);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // ============ API Methods ============

  Future<List<QuestInstance>> getQuestInstancesByDate(DateTime date) async {
    final api = _apiClient;
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (api == null) {
      final instances = await _loadFromCache();
      return instances.where((instance) {
        final instanceDate = DateTime(
          instance.date.year,
          instance.date.month,
          instance.date.day,
        );
        return instanceDate.isAtSameMomentAs(dateOnly);
      }).toList();
    }
    
    try {
      final response = await api.get('/quests', queryParams: {
        'date': date.toUtc().toIso8601String(),
      });
      return (response as List)
          .map((json) => _mapApiToQuestInstance(json))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      final instances = await _loadFromCache();
      return instances.where((instance) {
        final instanceDate = DateTime(
          instance.date.year,
          instance.date.month,
          instance.date.day,
        );
        return instanceDate.isAtSameMomentAs(dateOnly);
      }).toList();
    }
  }

  Future<void> upsertQuestInstance(QuestInstance instance) async {
    final api = _apiClient;
    if (api == null) {
      final instances = await _loadFromCache();
      final index = instances.indexWhere((i) => i.id == instance.id);
      if (index != -1) {
        instances[index] = instance;
      } else {
        instances.add(instance);
      }
      await _saveToCache(instances);
      return;
    }
    
    // Try update first, then create
    try {
      await api.put('/quests/${instance.id}', body: _mapQuestInstanceToApi(instance));
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        await api.post('/quests', body: _mapQuestInstanceToApi(instance));
      } else {
        rethrow;
      }
    }
  }

  Future<List<QuestInstance>> getQuestInstancesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final api = _apiClient;
    if (api == null) {
      final instances = await _loadFromCache();
      return instances
          .where((instance) =>
              instance.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              instance.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    }
    
    try {
      final response = await api.get('/quests', queryParams: {
        'start': startDate.toUtc().toIso8601String(),
        'end': endDate.toUtc().toIso8601String(),
      });
      final items = (response as List)
          .map((json) => _mapApiToQuestInstance(json))
          .toList();
      // Update cache
      final allInstances = await _loadFromCache();
      for (final item in items) {
        final idx = allInstances.indexWhere((i) => i.id == item.id);
        if (idx != -1) {
          allInstances[idx] = item;
        } else {
          allInstances.add(item);
        }
      }
      await _saveToCache(allInstances);
      return items;
    } on ApiException {
      rethrow;
    } catch (e) {
      final instances = await _loadFromCache();
      return instances
          .where((instance) =>
              instance.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              instance.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    }
  }

  Future<void> deleteQuestInstance(String id) async {
    final api = _apiClient;
    if (api == null) {
      final instances = await _loadFromCache();
      instances.removeWhere((instance) => instance.id == id);
      await _saveToCache(instances);
      return;
    }
    
    await api.delete('/quests/$id');
  }
  
  // ============ Mapping Helpers ============
  
  QuestInstance _mapApiToQuestInstance(Map<String, dynamic> json) {
    final statusStr = json['status'] ?? 'todo';
    return QuestInstance(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      templateId: json['template_id'] ?? '',
      status: QuestStatus.values.firstWhere(
        (e) => e.name == statusStr,
        orElse: () => QuestStatus.todo,
      ),
      xpAwarded: json['xp_awarded'] ?? 0,
      note: json['note'],
    );
  }
  
  Map<String, dynamic> _mapQuestInstanceToApi(QuestInstance instance) {
    return {
      'date': instance.date.toUtc().toIso8601String(),
      'template_id': instance.templateId,
      'status': instance.status.name,
      'xp_awarded': instance.xpAwarded,
      'note': instance.note,
    };
  }
}
