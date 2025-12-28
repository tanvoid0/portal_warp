import '../models/user_prefs.dart';
import '../models/focus_area.dart';
import '../models/energy_level.dart';
import '../local/json_storage.dart';

/// Repository for user preferences using JSON file storage
class PrefsRepository {
  static const String _filename = 'user_prefs.json';

  Future<UserPrefs> getPrefs() async {
    final data = await JsonStorage.readObject(_filename);
    if (data == null) {
      // Return default prefs
      return const UserPrefs(
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
    }

    // Convert enum keys from strings
    final enabledAreas = <FocusArea, bool>{};
    if (data['enabledFocusAreas'] != null) {
      (data['enabledFocusAreas'] as Map).forEach((key, value) {
        enabledAreas[FocusArea.values.firstWhere((e) => e.name == key)] = value as bool;
      });
    }

    final priority = <FocusArea, int>{};
    if (data['priority'] != null) {
      (data['priority'] as Map).forEach((key, value) {
        priority[FocusArea.values.firstWhere((e) => e.name == key)] = value as int;
      });
    }

    final weeklyTarget = <FocusArea, int>{};
    if (data['weeklyTarget'] != null) {
      (data['weeklyTarget'] as Map).forEach((key, value) {
        weeklyTarget[FocusArea.values.firstWhere((e) => e.name == key)] = value as int;
      });
    }

    return UserPrefs(
      enabledFocusAreas: enabledAreas,
      priority: priority,
      weeklyTarget: weeklyTarget,
      timeBudgetMinutes: data['timeBudgetMinutes'] as int? ?? 20,
      difficultyCap: data['difficultyCap'] as int? ?? 5,
      defaultEnergy: EnergyLevel.values.firstWhere(
        (e) => e.name == (data['defaultEnergy'] as String? ?? 'medium'),
      ),
    );
  }

  Future<void> savePrefs(UserPrefs prefs) async {
    final json = prefs.toJson();
    // Convert enum keys to strings for JSON
    final enabledAreas = <String, bool>{};
    prefs.enabledFocusAreas.forEach((key, value) {
      enabledAreas[key.name] = value;
    });
    json['enabledFocusAreas'] = enabledAreas;

    final priority = <String, int>{};
    prefs.priority.forEach((key, value) {
      priority[key.name] = value;
    });
    json['priority'] = priority;

    final weeklyTarget = <String, int>{};
    prefs.weeklyTarget.forEach((key, value) {
      weeklyTarget[key.name] = value;
    });
    json['weeklyTarget'] = weeklyTarget;

    json['defaultEnergy'] = prefs.defaultEnergy.name;

    await JsonStorage.writeObject(_filename, json);
  }
}
