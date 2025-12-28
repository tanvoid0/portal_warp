import '../models/quest_instance.dart';
import '../local/json_storage.dart';

/// Repository for quest instances using JSON file storage
class QuestsRepository {
  static const String _filename = 'quest_instances.json';

  Future<List<QuestInstance>> _loadInstances() async {
    final data = await JsonStorage.readList(_filename);
    return data.map((json) {
      // Handle DateTime parsing
      if (json['date'] is String) {
        json['date'] = DateTime.parse(json['date']).toIso8601String();
      }
      return QuestInstance.fromJson(json);
    }).toList();
  }

  Future<void> _saveInstances(List<QuestInstance> instances) async {
    final data = instances.map((i) {
      final json = i.toJson();
      // Ensure date is stored as ISO string
      json['date'] = i.date.toIso8601String();
      return json;
    }).toList();
    await JsonStorage.writeList(_filename, data);
  }

  Future<List<QuestInstance>> getQuestInstancesByDate(DateTime date) async {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final instances = await _loadInstances();
    return instances
        .where((instance) {
          final instanceDate = DateTime(
            instance.date.year,
            instance.date.month,
            instance.date.day,
          );
          return instanceDate.isAtSameMomentAs(dateOnly);
        })
        .toList();
  }

  Future<void> upsertQuestInstance(QuestInstance instance) async {
    final instances = await _loadInstances();
    final index = instances.indexWhere((i) => i.id == instance.id);
    if (index != -1) {
      instances[index] = instance;
    } else {
      instances.add(instance);
    }
    await _saveInstances(instances);
  }

  Future<List<QuestInstance>> getQuestInstancesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final instances = await _loadInstances();
    return instances
        .where((instance) =>
            instance.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            instance.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();
  }

  Future<void> deleteQuestInstance(String id) async {
    final instances = await _loadInstances();
    instances.removeWhere((instance) => instance.id == id);
    await _saveInstances(instances);
  }
}
