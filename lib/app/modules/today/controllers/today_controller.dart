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
import '../../../core/theme/design_tokens.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

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

      // Load drawer status
      await _loadDrawerStatus();

      // Load shopping items
      await _loadShoppingItems();

      // Load today's plans
      await _loadTodayPlans();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateQuests() async {
    final quests = await _questGenerator.generateTodayQuests(
      userPrefs.value,
      energyLevel.value,
    );

    // Load template details for each quest
    final templates = <String, QuestTemplate>{};
    for (final quest in quests) {
      final template = await _templatesRepo.getTemplateById(quest.templateId);
      if (template != null) {
        templates[quest.templateId] = template;
      }
    }

    todayQuests.value = quests;
    questTemplates.value = templates;
  }

  Future<void> selectEnergy(EnergyLevel level) async {
    energyLevel.value = level;
    await generateQuests();
  }

  Future<void> completeQuest(String questId) async {
    final quest = todayQuests.firstWhere((q) => q.id == questId);
    final template = questTemplates[quest.templateId];

    if (template == null) return;

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
  }

  Future<void> _updateXPAndStreak() async {
    final totalXP = await _xpService.getTotalXP();
    xp.value = totalXP;
    level.value = _xpService.getLevel(totalXP);
    streak.value = await _xpService.getStreak();
  }

  Future<void> _loadDrawerStatus() async {
    drawerStatus.value = await _drawerService.getDrawerStatus();
  }

  Future<void> _loadShoppingItems() async {
    pendingShopping.value = await _shoppingService.getPendingItems();
  }

  Future<void> _loadTodayPlans() async {
    todayPlans.value = await _planService.getTodayPlans();
  }

  Gradient getQuestGradient(String focusArea) {
    switch (focusArea) {
      case 'clothes':
        return DesignTokens.clothesGradient;
      case 'skincare':
        return DesignTokens.skincareGradient;
      case 'fitness':
        return DesignTokens.fitnessGradient;
      case 'cooking':
        return DesignTokens.cookingGradient;
      default:
        return DesignTokens.questGradient;
    }
  }
}
