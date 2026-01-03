import 'package:get/get.dart';
import '../models/user_prefs.dart';
import '../models/focus_area.dart';
import '../models/energy_level.dart';
import '../local/json_storage.dart';
import '../../core/services/api_client.dart';

/// Repository for user preferences with hybrid sync (API + local cache)
class PrefsRepository {
  static const String _cacheFilename = 'user_prefs_cache.json';
  
  ApiClient? get _apiClient {
    try {
      return Get.find<ApiClient>();
    } catch (_) {
      return null;
    }
  }

  // ============ Default Prefs ============
  
  UserPrefs get _defaultPrefs => const UserPrefs(
    enabledFocusAreas: {
      FocusArea.clothes: true,
      FocusArea.skincare: true,
      FocusArea.fitness: true,
      FocusArea.cooking: true,
    },
    priority: {
      FocusArea.clothes: 5,
      FocusArea.skincare: 3,
      FocusArea.fitness: 4,
      FocusArea.cooking: 3,
    },
    weeklyTarget: {
      FocusArea.clothes: 3,
      FocusArea.skincare: 5,
      FocusArea.fitness: 3,
      FocusArea.cooking: 2,
    },
    timeBudgetMinutes: 20,
    difficultyCap: 5,
    defaultEnergy: EnergyLevel.medium,
  );

  // ============ Cache Methods ============

  Future<UserPrefs?> _loadFromCache() async {
    final data = await JsonStorage.readObject(_cacheFilename);
    if (data == null) return null;
    
    try {
      return _mapJsonToPrefs(data);
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveToCache(UserPrefs prefs) async {
    try {
      final json = _mapPrefsToJson(prefs);
      await JsonStorage.writeObject(_cacheFilename, json);
    } catch (e) {
      // Ignore cache errors
    }
  }

  // ============ API Methods ============

  Future<UserPrefs> getPrefs() async {
    final api = _apiClient;
    if (api == null) {
      final cached = await _loadFromCache();
      return cached ?? _defaultPrefs;
    }
    
    try {
      final response = await api.get('/prefs');
      final prefs = _mapApiToPrefs(response);
      await _saveToCache(prefs);
      return prefs;
    } on ApiException {
      rethrow;
    } catch (e) {
      final cached = await _loadFromCache();
      return cached ?? _defaultPrefs;
    }
  }

  Future<void> savePrefs(UserPrefs prefs) async {
    final api = _apiClient;
    if (api == null) {
      await _saveToCache(prefs);
      return;
    }
    
    await api.put('/prefs', body: _mapPrefsToApi(prefs));
    await _saveToCache(prefs);
  }
  
  // ============ Mapping Helpers ============
  
  UserPrefs _mapApiToPrefs(Map<String, dynamic> json) {
    final enabledAreas = <FocusArea, bool>{};
    if (json['enabled_focus_areas'] != null) {
      (json['enabled_focus_areas'] as Map).forEach((key, value) {
        final area = FocusArea.values.firstWhere((e) => e.name == key, orElse: () => FocusArea.clothes);
        enabledAreas[area] = value as bool;
      });
    }
    
    final priority = <FocusArea, int>{};
    if (json['priority'] != null) {
      (json['priority'] as Map).forEach((key, value) {
        final area = FocusArea.values.firstWhere((e) => e.name == key, orElse: () => FocusArea.clothes);
        priority[area] = value as int;
      });
    }
    
    final weeklyTarget = <FocusArea, int>{};
    if (json['weekly_target'] != null) {
      (json['weekly_target'] as Map).forEach((key, value) {
        final area = FocusArea.values.firstWhere((e) => e.name == key, orElse: () => FocusArea.clothes);
        weeklyTarget[area] = value as int;
      });
    }
    
    return UserPrefs(
      enabledFocusAreas: enabledAreas.isEmpty ? _defaultPrefs.enabledFocusAreas : enabledAreas,
      priority: priority.isEmpty ? _defaultPrefs.priority : priority,
      weeklyTarget: weeklyTarget.isEmpty ? _defaultPrefs.weeklyTarget : weeklyTarget,
      timeBudgetMinutes: json['time_budget_minutes'] as int? ?? 20,
      difficultyCap: json['difficulty_cap'] as int? ?? 5,
      defaultEnergy: EnergyLevel.values.firstWhere(
        (e) => e.name == (json['default_energy'] as String? ?? 'medium'),
        orElse: () => EnergyLevel.medium,
      ),
    );
  }
  
  Map<String, dynamic> _mapPrefsToApi(UserPrefs prefs) {
    final enabledAreas = <String, bool>{};
    prefs.enabledFocusAreas.forEach((key, value) {
      enabledAreas[key.name] = value;
    });
    
    final priority = <String, int>{};
    prefs.priority.forEach((key, value) {
      priority[key.name] = value;
    });
    
    final weeklyTarget = <String, int>{};
    prefs.weeklyTarget.forEach((key, value) {
      weeklyTarget[key.name] = value;
    });
    
    return {
      'enabled_focus_areas': enabledAreas,
      'priority': priority,
      'weekly_target': weeklyTarget,
      'time_budget_minutes': prefs.timeBudgetMinutes,
      'difficulty_cap': prefs.difficultyCap,
      'default_energy': prefs.defaultEnergy.name,
    };
  }
  
  UserPrefs _mapJsonToPrefs(Map<String, dynamic> json) {
    final enabledAreas = <FocusArea, bool>{};
    if (json['enabledFocusAreas'] != null) {
      (json['enabledFocusAreas'] as Map).forEach((key, value) {
        enabledAreas[FocusArea.values.firstWhere((e) => e.name == key)] = value as bool;
      });
    }

    final priority = <FocusArea, int>{};
    if (json['priority'] != null) {
      (json['priority'] as Map).forEach((key, value) {
        priority[FocusArea.values.firstWhere((e) => e.name == key)] = value as int;
      });
    }

    final weeklyTarget = <FocusArea, int>{};
    if (json['weeklyTarget'] != null) {
      (json['weeklyTarget'] as Map).forEach((key, value) {
        weeklyTarget[FocusArea.values.firstWhere((e) => e.name == key)] = value as int;
      });
    }

    return UserPrefs(
      enabledFocusAreas: enabledAreas,
      priority: priority,
      weeklyTarget: weeklyTarget,
      timeBudgetMinutes: json['timeBudgetMinutes'] as int? ?? 20,
      difficultyCap: json['difficultyCap'] as int? ?? 5,
      defaultEnergy: EnergyLevel.values.firstWhere(
        (e) => e.name == (json['defaultEnergy'] as String? ?? 'medium'),
      ),
    );
  }
  
  Map<String, dynamic> _mapPrefsToJson(UserPrefs prefs) {
    final enabledAreas = <String, bool>{};
    prefs.enabledFocusAreas.forEach((key, value) {
      enabledAreas[key.name] = value;
    });

    final priority = <String, int>{};
    prefs.priority.forEach((key, value) {
      priority[key.name] = value;
    });

    final weeklyTarget = <String, int>{};
    prefs.weeklyTarget.forEach((key, value) {
      weeklyTarget[key.name] = value;
    });

    return {
      'enabledFocusAreas': enabledAreas,
      'priority': priority,
      'weeklyTarget': weeklyTarget,
      'timeBudgetMinutes': prefs.timeBudgetMinutes,
      'difficultyCap': prefs.difficultyCap,
      'defaultEnergy': prefs.defaultEnergy.name,
    };
  }
}
