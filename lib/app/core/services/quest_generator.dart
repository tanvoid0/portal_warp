import 'dart:math';
import '../../data/models/quest_template.dart';
import '../../data/models/quest_instance.dart';
import '../../data/models/user_prefs.dart';
import '../../data/models/energy_level.dart';
import '../../data/models/focus_area.dart';
import '../../data/repositories/templates_repository.dart';
import '../../data/repositories/quests_repository.dart';
import '../../data/repositories/drawer_repository.dart';
import '../../data/repositories/shopping_repository.dart';

class QuestGenerator {
  final TemplatesRepository _templatesRepo;
  final QuestsRepository _questsRepo;
  final DrawerRepository _drawerRepo;
  final ShoppingRepository _shoppingRepo;
  final Random _random = Random();

  QuestGenerator(
    this._templatesRepo,
    this._questsRepo,
    this._drawerRepo,
    this._shoppingRepo,
  );

  Future<List<QuestInstance>> generateTodayQuests(
    UserPrefs prefs,
    EnergyLevel energy,
  ) async {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    // Get enabled focus areas
    final enabledAreas = prefs.enabledFocusAreas.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    if (enabledAreas.isEmpty) {
      return [];
    }

    // Get all templates for enabled areas
    final allTemplates = await _templatesRepo.getTemplatesByFocusAreas(enabledAreas);

    // Get quest history for last 14 days
    final history = await _questsRepo.getQuestInstancesByDateRange(
      todayStart.subtract(const Duration(days: 14)),
      todayStart,
    );

    // Calculate adaptive difficulty
    final adaptiveDifficulty = _calculateAdaptiveDifficulty(history, prefs);

    // Filter templates by difficulty cap and adaptive difficulty
    final availableTemplates = allTemplates.where((template) {
      return template.difficulty <= prefs.difficultyCap &&
          template.difficulty <= adaptiveDifficulty;
    }).toList();

    // Always include 1 tiny (2 min) quest
    final tinyQuest = await _generateQuest(
      availableTemplates,
      history,
      2,
      enabledAreas,
      todayStart,
    );

    // Always include 1 medium (10 min) quest
    final mediumQuest = await _generateQuest(
      availableTemplates,
      history,
      10,
      enabledAreas,
      todayStart,
    );

    final quests = [tinyQuest, mediumQuest];

    // Include boss (30 min) only if energy != low AND timeBudget allows
    if (energy != EnergyLevel.low && prefs.timeBudgetMinutes >= 30) {
      final bossQuest = await _generateQuest(
        availableTemplates,
        history,
        30,
        enabledAreas,
        todayStart,
      );
      if (bossQuest != null) {
        quests.add(bossQuest);
      }
    }

    // Consider drawer status for clothes quests
    await _adjustForDrawerStatus(quests);

    // Consider shopping list for cooking quests
    await _adjustForShoppingList(quests);

    return quests.whereType<QuestInstance>().toList();
  }

  Future<QuestInstance?> _generateQuest(
    List<QuestTemplate> templates,
    List<QuestInstance> history,
    int durationBucket,
    List<FocusArea> enabledAreas,
    DateTime date,
  ) async {
    // Filter by duration
    final durationTemplates = templates
        .where((t) => t.durationBucket == durationBucket)
        .toList();

    if (durationTemplates.isEmpty) {
      return null;
    }

    // Get recently used template IDs
    final recentTemplateIds = history
        .where((h) => h.date.isAfter(date.subtract(const Duration(days: 7))))
        .map((h) => h.templateId)
        .toSet();

    // Filter out templates that are on cooldown or recently used
    final availableTemplates = durationTemplates.where((template) {
      // Check cooldown
      final lastUsed = history
          .where((h) => h.templateId == template.id)
          .map((h) => h.date)
          .fold<DateTime?>(null, (latest, date) {
        if (latest == null) return date;
        return date.isAfter(latest) ? date : latest;
      });

      if (lastUsed != null) {
        final daysSinceUsed = date.difference(lastUsed).inDays;
        if (daysSinceUsed < template.cooldownDays) {
          return false;
        }
      }

      // Avoid recently used templates (unless library is small)
      if (durationTemplates.length > 5 && recentTemplateIds.contains(template.id)) {
        return false;
      }

      return true;
    }).toList();

    // If no templates available after filtering, use all duration templates
    final candidates = availableTemplates.isNotEmpty
        ? availableTemplates
        : durationTemplates;

    // Weight by priority if available (for now, random selection)
    final selectedTemplate = candidates[_random.nextInt(candidates.length)];

    return QuestInstance(
      id: 'quest_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(1000)}',
      date: date,
      templateId: selectedTemplate.id,
      status: QuestStatus.todo,
    );
  }

  int _calculateAdaptiveDifficulty(
    List<QuestInstance> history,
    UserPrefs prefs,
  ) {
    if (history.isEmpty) {
      return prefs.difficultyCap;
    }

    // Check last 7 days
    final last7Days = history.where((h) =>
        h.date.isAfter(DateTime.now().subtract(const Duration(days: 7))));

    final completedCount = last7Days
        .where((h) => h.status.name == 'done')
        .length;

    // If completed >= 5/7 days, increase difficulty
    if (completedCount >= 5) {
      return (prefs.difficultyCap).clamp(1, 5);
    }

    // If missed 2+ days, reduce difficulty
    final missedDays = 7 - completedCount;
    if (missedDays >= 2) {
      return (prefs.difficultyCap - 1).clamp(1, 5);
    }

    return prefs.difficultyCap;
  }

  Future<void> _adjustForDrawerStatus(List<QuestInstance?> quests) async {
    final drawerStatus = await _drawerRepo.getDrawerStatus();
    final percentage = (drawerStatus['percentage'] as num?)?.toDouble() ?? 1.0;
    final needsOrganization = percentage < 0.5;

    // If drawer needs organization, bias toward clothes quests
    if (needsOrganization) {
      // This is a placeholder - in full implementation, we'd adjust quest selection
    }
  }

  Future<void> _adjustForShoppingList(List<QuestInstance?> quests) async {
    final pendingItems = await _shoppingRepo.getPendingItems();
    
    // If there are pending shopping items, consider suggesting cooking quests
    if (pendingItems.isNotEmpty) {
      // This is a placeholder - in full implementation, we'd adjust quest selection
    }
  }
}

