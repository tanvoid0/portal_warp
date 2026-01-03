import 'package:get/get.dart';
import '../models/quest_template.dart';
import '../models/focus_area.dart';
import '../local/json_storage.dart';
import '../../core/services/api_client.dart';

/// Repository for quest templates with hybrid sync (API + local cache)
class TemplatesRepository {
  static const String _cacheFilename = 'templates_cache.json';
  
  ApiClient? get _apiClient {
    try {
      return Get.find<ApiClient>();
    } catch (_) {
      return null;
    }
  }

  // ============ Cache Methods ============

  Future<List<QuestTemplate>> _loadFromCache() async {
    try {
      final data = await JsonStorage.readList(_cacheFilename);
      return data.map((json) {
        try {
          return QuestTemplate.fromJson(json);
        } catch (e) {
          return null;
        }
      }).whereType<QuestTemplate>().toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveToCache(List<QuestTemplate> templates) async {
    try {
      final data = templates.map((t) => t.toJson()).toList();
      await JsonStorage.writeList(_cacheFilename, data);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // ============ API Methods ============

  Future<void> seedTemplatesIfEmpty() async {
    final api = _apiClient;
    if (api == null) {
      // Seed locally
      final templates = await _loadFromCache();
      if (templates.isNotEmpty) return;
      await _saveToCache(_getDefaultTemplates());
      return;
    }
    
    try {
      await api.post('/templates/seed');
    } catch (e) {
      // Ignore seed errors
    }
  }

  Future<List<QuestTemplate>> getTemplatesByFocusAreas(
    List<FocusArea> focusAreas,
  ) async {
    final api = _apiClient;
    if (api == null) {
      final templates = await _loadFromCache();
      return templates
          .where((template) => focusAreas.contains(template.focusAreaId))
          .toList();
    }
    
    try {
      final areasStr = focusAreas.map((a) => a.name).join(',');
      final response = await api.get('/templates', queryParams: {'focus_areas': areasStr});
      final items = (response as List)
          .map((json) => _mapApiToTemplate(json))
          .toList();
      // Update cache with fresh data
      final allTemplates = await _loadFromCache();
      for (final item in items) {
        final idx = allTemplates.indexWhere((t) => t.id == item.id);
        if (idx != -1) {
          allTemplates[idx] = item;
        } else {
          allTemplates.add(item);
        }
      }
      await _saveToCache(allTemplates);
      return items;
    } on ApiException {
      rethrow;
    } catch (e) {
      final templates = await _loadFromCache();
      return templates
          .where((template) => focusAreas.contains(template.focusAreaId))
          .toList();
    }
  }

  Future<List<QuestTemplate>> getAllTemplates() async {
    final api = _apiClient;
    if (api == null) return _loadFromCache();
    
    try {
      final response = await api.get('/templates');
      final items = (response as List)
          .map((json) => _mapApiToTemplate(json))
          .toList();
      await _saveToCache(items);
      return items;
    } on ApiException {
      rethrow;
    } catch (e) {
      return _loadFromCache();
    }
  }

  Future<QuestTemplate?> getTemplateById(String id) async {
    final api = _apiClient;
    if (api == null) {
      final templates = await _loadFromCache();
      try {
        return templates.firstWhere((template) => template.id == id);
      } catch (e) {
        return null;
      }
    }
    
    try {
      final response = await api.get('/templates/$id');
      return _mapApiToTemplate(response);
    } catch (e) {
      final templates = await _loadFromCache();
      try {
        return templates.firstWhere((template) => template.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  Future<void> addTemplate(QuestTemplate template) async {
    final api = _apiClient;
    if (api == null) {
      final templates = await _loadFromCache();
      templates.add(template);
      await _saveToCache(templates);
      return;
    }
    
    await api.post('/templates', body: _mapTemplateToApi(template));
  }

  Future<void> updateTemplate(QuestTemplate template) async {
    final api = _apiClient;
    if (api == null) {
      final templates = await _loadFromCache();
      final index = templates.indexWhere((t) => t.id == template.id);
      if (index != -1) {
        templates[index] = template;
        await _saveToCache(templates);
      }
      return;
    }
    
    await api.put('/templates/${template.id}', body: _mapTemplateToApi(template));
  }

  Future<void> deleteTemplate(String id) async {
    final api = _apiClient;
    if (api == null) {
      final templates = await _loadFromCache();
      templates.removeWhere((template) => template.id == id);
      await _saveToCache(templates);
      return;
    }
    
    await api.delete('/templates/$id');
  }
  
  // ============ Mapping Helpers ============
  
  QuestTemplate _mapApiToTemplate(Map<String, dynamic> json) {
    final focusAreaStr = json['focus_area_id'] ?? 'clothes';
    return QuestTemplate(
      id: json['id'] ?? '',
      focusAreaId: FocusArea.values.firstWhere(
        (e) => e.name == focusAreaStr,
        orElse: () => FocusArea.clothes,
      ),
      title: json['title'] ?? '',
      durationBucket: json['duration_bucket'] ?? 10,
      difficulty: json['difficulty'] ?? 3,
      cooldownDays: json['cooldown_days'] ?? 0,
      instructions: json['instructions'] ?? '',
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
    );
  }
  
  Map<String, dynamic> _mapTemplateToApi(QuestTemplate template) {
    return {
      'focus_area_id': template.focusAreaId.name,
      'title': template.title,
      'duration_bucket': template.durationBucket,
      'difficulty': template.difficulty,
      'cooldown_days': template.cooldownDays,
      'instructions': template.instructions,
      'tags': template.tags,
    };
  }
  
  List<QuestTemplate> _getDefaultTemplates() {
    return [
      const QuestTemplate(id: 'clothes_1', focusAreaId: FocusArea.clothes, title: 'Remove 10 non-clothes items from drawer', durationBucket: 2, difficulty: 1),
      const QuestTemplate(id: 'clothes_2', focusAreaId: FocusArea.clothes, title: 'Fold and file 10 shirts', durationBucket: 10, difficulty: 2),
      const QuestTemplate(id: 'skincare_1', focusAreaId: FocusArea.skincare, title: 'Morning: Rinse + moisturize + SPF', durationBucket: 2, difficulty: 1),
      const QuestTemplate(id: 'fitness_1', focusAreaId: FocusArea.fitness, title: 'Walk 10 minutes daily', durationBucket: 10, difficulty: 2),
      const QuestTemplate(id: 'cooking_1', focusAreaId: FocusArea.cooking, title: 'Choose tomorrow\'s meal', durationBucket: 2, difficulty: 1),
    ];
  }
}
