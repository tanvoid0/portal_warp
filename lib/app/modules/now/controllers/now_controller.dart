import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/plan_item.dart';
import '../../../data/models/shopping_item.dart';
import '../../../data/repositories/plan_repository.dart';
import '../../../data/repositories/shopping_repository.dart';
import '../../../data/repositories/prefs_repository.dart';
import '../../../data/repositories/quests_repository.dart';
import '../../../core/services/plan_service.dart';
import '../../../core/services/xp_service.dart';

/// Time period of the day for contextual content
enum TimePeriod {
  morning,   // 5am - 12pm
  afternoon, // 12pm - 5pm
  evening,   // 5pm - 9pm
  night,     // 9pm - 5am
}

/// Controller for the "Now" view - time-aware, action-focused home screen
class NowController extends GetxController {
  final PlanRepository _planRepo = PlanRepository();
  final ShoppingRepository _shoppingRepo = ShoppingRepository();
  final PrefsRepository _prefsRepo = PrefsRepository();
  final QuestsRepository _questsRepo = QuestsRepository();
  
  late final PlanService _planService;
  late final XPService _xpService;

  // Observables
  final isLoading = true.obs;
  final currentTime = DateTime.now().obs;
  final timePeriod = TimePeriod.morning.obs;
  
  // Active tasks for current time
  final activeTasks = <PlanItem>[].obs;
  final urgentShopping = <ShoppingItem>[].obs;
  
  // Progress tracking (simplified from XP)
  final streak = 0.obs;
  final todayProgress = 0.0.obs; // 0.0 to 1.0
  final todayCompleted = 0.obs;
  final todayTotal = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initServices();
    _loadData();
    _startTimeUpdater();
  }

  void _initServices() {
    _planService = PlanService(_planRepo);
    _xpService = XPService(_questsRepo);
  }

  void _startTimeUpdater() {
    // Update time context every minute
    ever(currentTime, (_) => _updateTimePeriod());
    Future.delayed(const Duration(minutes: 1), () {
      currentTime.value = DateTime.now();
      _startTimeUpdater();
    });
  }

  void _updateTimePeriod() {
    final hour = currentTime.value.hour;
    if (hour >= 5 && hour < 12) {
      timePeriod.value = TimePeriod.morning;
    } else if (hour >= 12 && hour < 17) {
      timePeriod.value = TimePeriod.afternoon;
    } else if (hour >= 17 && hour < 21) {
      timePeriod.value = TimePeriod.evening;
    } else {
      timePeriod.value = TimePeriod.night;
    }
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _loadActiveTasks(),
        _loadUrgentShopping(),
        _loadProgress(),
      ]);
      _updateTimePeriod();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadActiveTasks() async {
    try {
      final todayPlans = await _planService.getTodayPlans();
      
      // Sort by time and filter based on current time period
      final now = DateTime.now();
      final sorted = todayPlans.where((p) => p.status != PlanStatus.completed).toList()
        ..sort((a, b) {
          if (a.time == null && b.time == null) return 0;
          if (a.time == null) return 1;
          if (b.time == null) return -1;
          return a.time!.compareTo(b.time!);
        });
      
      activeTasks.value = sorted;
      todayTotal.value = todayPlans.length;
      todayCompleted.value = todayPlans.where((p) => p.status == PlanStatus.completed).length;
      
      // Calculate progress
      if (todayPlans.isNotEmpty) {
        todayProgress.value = todayCompleted.value / todayPlans.length;
      }
    } catch (e) {
      activeTasks.value = [];
    }
  }

  Future<void> _loadUrgentShopping() async {
    try {
      final items = await _shoppingRepo.getShoppingItems();
      // Show high priority pending items
      urgentShopping.value = items
          .where((item) => 
              item.status != ShoppingStatus.purchased && 
              item.priority >= 3)
          .take(3)
          .toList();
    } catch (e) {
      urgentShopping.value = [];
    }
  }

  Future<void> _loadProgress() async {
    try {
      streak.value = await _xpService.getStreak();
    } catch (e) {
      streak.value = 0;
    }
  }

  /// Get the greeting based on time of day
  String get greeting {
    switch (timePeriod.value) {
      case TimePeriod.morning:
        return 'Good morning';
      case TimePeriod.afternoon:
        return 'Good afternoon';
      case TimePeriod.evening:
        return 'Good evening';
      case TimePeriod.night:
        return 'Good night';
    }
  }

  /// Get contextual prompt based on time
  String get contextualPrompt {
    final pending = activeTasks.where((t) => t.status != PlanStatus.completed).length;
    
    switch (timePeriod.value) {
      case TimePeriod.morning:
        if (pending == 0) return "You're all caught up!";
        return '$pending tasks for your morning routine';
      case TimePeriod.afternoon:
        if (pending == 0) return 'Afternoon looking clear';
        return '$pending tasks remaining today';
      case TimePeriod.evening:
        if (pending == 0) return 'Evening routine complete';
        return '$pending tasks for tonight';
      case TimePeriod.night:
        if (pending == 0) return 'All done for today!';
        return 'Wrap up your day';
    }
  }

  /// Get icon for current time period
  IconData get timePeriodIcon {
    switch (timePeriod.value) {
      case TimePeriod.morning:
        return Icons.wb_sunny;
      case TimePeriod.afternoon:
        return Icons.wb_cloudy;
      case TimePeriod.evening:
        return Icons.wb_twilight;
      case TimePeriod.night:
        return Icons.nightlight_round;
    }
  }

  /// Complete a task with one tap
  Future<void> completeTask(String taskId) async {
    try {
      await _planRepo.markCompleted(taskId);
      
      // Update local state immediately for responsiveness
      final index = activeTasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        activeTasks.removeAt(index);
        todayCompleted.value++;
        if (todayTotal.value > 0) {
          todayProgress.value = todayCompleted.value / todayTotal.value;
        }
      }
      
      // Refresh streak
      await _loadProgress();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to complete task',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Quick add a task for today
  Future<void> quickAddTask(String title, {String? time}) async {
    try {
      final item = PlanItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        date: DateTime.now(),
        time: time,
        category: '',
      );
      await _planRepo.addPlanItem(item);
      await _loadActiveTasks();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add task',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> refresh() async {
    await _loadData();
  }
}


