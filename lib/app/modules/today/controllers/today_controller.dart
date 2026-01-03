import 'package:get/get.dart';
import '../../../data/models/quest_instance.dart';
import '../../../data/models/quest_template.dart';
import '../../../data/models/user_prefs.dart';
import '../../../data/models/energy_level.dart';
import '../../../data/models/drawer_item.dart';
import '../../../data/models/shopping_item.dart';
import '../../../data/models/plan_item.dart';
import '../../../data/repositories/templates_repository.dart';
import '../../../data/repositories/quests_repository.dart';
import '../../../data/repositories/prefs_repository.dart';
import '../../../data/repositories/drawer_repository.dart';
import '../../../data/repositories/shopping_repository.dart';
import '../../../data/repositories/plan_repository.dart';
import '../../../core/services/quest_generator.dart';
import '../../../core/services/xp_service.dart';
import '../../../core/services/drawer_service.dart';
import '../../../core/services/shopping_service.dart';
import '../../../core/services/plan_service.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

class TodayController extends GetxController {
  // Repositories
  final TemplatesRepository _templatesRepo = TemplatesRepository();
  final QuestsRepository _questsRepo = QuestsRepository();
  final PrefsRepository _prefsRepo = PrefsRepository();
  final DrawerRepository _drawerRepo = DrawerRepository();
  final ShoppingRepository _shoppingRepo = ShoppingRepository();
  final PlanRepository _planRepo = PlanRepository();

  // Services
  late final QuestGenerator _questGenerator;
  late final XPService _xpService;
  late final DrawerService _drawerService;
  late final ShoppingService _shoppingService;
  late final PlanService _planService;

  // Observables
  final energyLevel = EnergyLevel.medium.obs;
  final todayQuests = <QuestInstance>[].obs;
  final questTemplates = <String, QuestTemplate>{}.obs;
  final xp = 0.obs;
  final level = 1.obs;
  final streak = 0.obs;
  int _previousStreak = 0;
  
  // Expose XP service for view
  XPService get xpService => _xpService;
  final drawerStatus = <String, dynamic>{}.obs;
  final pendingShopping = <ShoppingItem>[].obs;
  final todayPlans = <PlanItem>[].obs;
  final isLoading = true.obs;
  final userPrefs = const UserPrefs().obs;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    _loadData();
  }

  void _initializeServices() {
    _questGenerator = QuestGenerator(
      _templatesRepo,
      _questsRepo,
      _drawerRepo,
      _shoppingRepo,
    );
    _xpService = XPService(_questsRepo);
    _drawerService = DrawerService(_drawerRepo);
    _shoppingService = ShoppingService(_shoppingRepo);
    _planService = PlanService(_planRepo);
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      // Seed templates if empty
      await _templatesRepo.seedTemplatesIfEmpty();

      // Load user preferences
      userPrefs.value = await _prefsRepo.getPrefs();
      energyLevel.value = userPrefs.value.defaultEnergy;

      // Generate today's quests
      await generateQuests();

      // Load XP and streak
      await _updateXPAndStreak();
      _previousStreak = streak.value;

      // Load drawer status
      await _loadDrawerStatus();

      // Load shopping items
      await _loadShoppingItems();

      // Load today's plans
      await _loadTodayPlans();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateQuests() async {
    try {
      final quests = await _questGenerator.generateTodayQuests(
        userPrefs.value,
        energyLevel.value,
      );

      // Load template details for each quest
      final templates = <String, QuestTemplate>{};
      for (final quest in quests) {
        try {
          final template = await _templatesRepo.getTemplateById(quest.templateId);
          if (template != null) {
            templates[quest.templateId] = template;
          }
        } catch (e) {
          // Skip this quest if template can't be loaded
          continue;
        }
      }

      todayQuests.value = quests;
      questTemplates.value = templates;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate quests: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> selectEnergy(EnergyLevel level) async {
    try {
      energyLevel.value = level;
      await generateQuests();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update energy level: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> completeQuest(String questId) async {
    try {
      final quest = todayQuests.firstWhere((q) => q.id == questId);
      final template = questTemplates[quest.templateId];

      if (template == null) {
        Get.snackbar(
          'Error',
          'Quest template not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
        return;
      }

      // Calculate XP
      final xpAwarded = _xpService.calculateXP(template);

      // Update quest instance
      final completedQuest = quest.copyWith(
        status: QuestStatus.done,
        xpAwarded: xpAwarded,
      );

      await _questsRepo.upsertQuestInstance(completedQuest);

      // Update local state
      final index = todayQuests.indexWhere((q) => q.id == questId);
      if (index != -1) {
        todayQuests[index] = completedQuest;
      }

      // Update XP and streak
      await _updateXPAndStreak();
      
      // Check for streak celebration
      _checkStreakCelebration();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to complete quest: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> skipQuest(String questId) async {
    try {
      // Show dialog asking for optional skip reason
      final reason = await Get.dialog<String>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Skip Quest',
                style: DesignTokens.titleStyle,
              ),
              const SizedBox(height: DesignTokens.spacingL),
              Text(
                'Why are you skipping this quest? (Optional)',
                style: DesignTokens.bodyStyle,
              ),
              const SizedBox(height: DesignTokens.spacingM),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'e.g., Not feeling well, Too busy...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  ),
                ),
                maxLines: 3,
                onSubmitted: (value) => Get.back(result: value.isEmpty ? null : value),
              ),
              const SizedBox(height: DesignTokens.spacingXL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  ElevatedButton(
                    onPressed: () => Get.back(result: null),
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

      final quest = todayQuests.firstWhere((q) => q.id == questId);

      // Update quest instance
      final skippedQuest = quest.copyWith(
        status: QuestStatus.skip,
        note: reason,
      );

      await _questsRepo.upsertQuestInstance(skippedQuest);

      // Update local state
      final index = todayQuests.indexWhere((q) => q.id == questId);
      if (index != -1) {
        todayQuests[index] = skippedQuest;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to skip quest: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> _updateXPAndStreak() async {
    try {
      final totalXP = await _xpService.getTotalXP();
      xp.value = totalXP;
      level.value = _xpService.getLevel(totalXP);
      streak.value = await _xpService.getStreak();
    } catch (e) {
      // Silently fail - XP/streak are not critical
    }
  }

  Future<void> _loadDrawerStatus() async {
    try {
      drawerStatus.value = await _drawerService.getDrawerStatus();
    } catch (e) {
      drawerStatus.value = {'percentage': 0.0, 'totalItems': 0, 'organized': 0, 'unorganized': 0};
    }
  }

  Future<void> _loadShoppingItems() async {
    try {
      pendingShopping.value = await _shoppingService.getPendingItems();
    } catch (e) {
      pendingShopping.value = [];
    }
  }

  Future<void> _loadTodayPlans() async {
    try {
      todayPlans.value = await _planService.getTodayPlans();
    } catch (e) {
      todayPlans.value = [];
    }
  }

  void _checkStreakCelebration() {
    final currentStreak = streak.value;
    if (currentStreak > _previousStreak && currentStreak > 1) {
      _previousStreak = currentStreak;
      _showStreakCelebration(currentStreak);
    } else if (currentStreak > _previousStreak) {
      _previousStreak = currentStreak;
    }
  }

  void _showStreakCelebration(int streakDays) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        ),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingXL),
          decoration: BoxDecoration(
            gradient: DesignTokens.questGradient(Get.context!),
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 64,
              ),
              const SizedBox(height: DesignTokens.spacingL),
              Text(
                '🔥 Streak!',
                style: DesignTokens.headlineStyle.copyWith(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingM),
              Text(
                '$streakDays day streak!',
                style: DesignTokens.titleStyle.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXL),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingXL,
                    vertical: DesignTokens.spacingM,
                  ),
                ),
                child: const Text('Awesome!'),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Gradient getQuestGradient(BuildContext context, String focusArea) {
    switch (focusArea) {
      case 'clothes':
        return DesignTokens.clothesGradient(context);
      case 'skincare':
        return DesignTokens.skincareGradient(context);
      case 'fitness':
        return DesignTokens.fitnessGradient(context);
      case 'cooking':
        return DesignTokens.cookingGradient(context);
      default:
        return DesignTokens.questGradient(context);
    }
  }
}
