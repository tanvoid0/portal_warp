import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/plan_item.dart';
import '../../../data/repositories/plan_repository.dart';
import '../../../core/services/plan_service.dart';

/// Routine session type
enum RoutineSession {
  morning,
  evening,
  custom,
}

/// Controller for the unified Routines view
class RoutinesController extends GetxController with GetSingleTickerProviderStateMixin {
  final PlanRepository _planRepo = PlanRepository();
  late final PlanService _planService;
  
  // Tab controller for morning/evening
  late TabController tabController;
  
  // Observables
  final isLoading = true.obs;
  final selectedSession = RoutineSession.morning.obs;
  final morningTasks = <PlanItem>[].obs;
  final eveningTasks = <PlanItem>[].obs;
  
  // Smart defaults for first-time users
  static const List<Map<String, dynamic>> defaultMorningRoutine = [
    {'title': 'Wake up', 'time': 'Morning', 'order': 1},
    {'title': 'Drink water', 'time': 'Morning', 'order': 2},
    {'title': 'Morning skincare', 'time': 'Morning', 'order': 3},
    {'title': 'Get dressed', 'time': 'Morning', 'order': 4},
    {'title': 'Breakfast', 'time': 'Morning', 'order': 5},
  ];
  
  static const List<Map<String, dynamic>> defaultEveningRoutine = [
    {'title': 'Prepare tomorrow\'s outfit', 'time': 'Evening', 'order': 1},
    {'title': 'Evening skincare', 'time': 'Evening', 'order': 2},
    {'title': 'Review tomorrow', 'time': 'Evening', 'order': 3},
    {'title': 'Wind down', 'time': 'Evening', 'order': 4},
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_onTabChanged);
    _planService = PlanService(_planRepo);
    _loadRoutines();
  }

  @override
  void onClose() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
    super.onClose();
  }

  void _onTabChanged() {
    selectedSession.value = tabController.index == 0 
        ? RoutineSession.morning 
        : RoutineSession.evening;
  }

  Future<void> _loadRoutines() async {
    isLoading.value = true;
    try {
      final todayPlans = await _planService.getTodayPlans();
      
      // Split by time/session
      morningTasks.value = todayPlans
          .where((p) => _isMorningTask(p))
          .toList()
        ..sort((a, b) => _compareTaskOrder(a, b));
      
      eveningTasks.value = todayPlans
          .where((p) => _isEveningTask(p))
          .toList()
        ..sort((a, b) => _compareTaskOrder(a, b));
      
      // If empty, offer to create defaults
      if (morningTasks.isEmpty && eveningTasks.isEmpty) {
        // First time user - could auto-populate or show prompt
      }
    } finally {
      isLoading.value = false;
    }
  }

  bool _isMorningTask(PlanItem item) {
    final time = item.time?.toLowerCase() ?? '';
    return time.contains('morning') || 
           time.contains('am') ||
           time.contains('wake') ||
           time.contains('breakfast');
  }

  bool _isEveningTask(PlanItem item) {
    final time = item.time?.toLowerCase() ?? '';
    return time.contains('evening') || 
           time.contains('night') ||
           time.contains('pm') ||
           time.contains('sleep') ||
           time.contains('bed');
  }

  int _compareTaskOrder(PlanItem a, PlanItem b) {
    // Sort by time string if available
    if (a.time == null && b.time == null) return 0;
    if (a.time == null) return 1;
    if (b.time == null) return -1;
    return a.time!.compareTo(b.time!);
  }

  /// Get current routine tasks based on selected session
  List<PlanItem> get currentTasks {
    return selectedSession.value == RoutineSession.morning 
        ? morningTasks 
        : eveningTasks;
  }

  /// Complete a routine task with swipe
  Future<void> completeTask(String taskId) async {
    try {
      await _planRepo.markCompleted(taskId);
      
      // Update local state
      if (selectedSession.value == RoutineSession.morning) {
        final index = morningTasks.indexWhere((t) => t.id == taskId);
        if (index != -1) {
          morningTasks[index] = morningTasks[index].copyWith(
            status: PlanStatus.completed,
          );
        }
      } else {
        final index = eveningTasks.indexWhere((t) => t.id == taskId);
        if (index != -1) {
          eveningTasks[index] = eveningTasks[index].copyWith(
            status: PlanStatus.completed,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to complete task',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Quick add a task to current routine
  Future<void> addToRoutine(String title) async {
    try {
      final time = selectedSession.value == RoutineSession.morning 
          ? 'Morning' 
          : 'Evening';
      
      final item = PlanItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        date: DateTime.now(),
        time: time,
        category: 'Routine',
      );
      
      await _planRepo.addPlanItem(item);
      
      // Add to local state
      if (selectedSession.value == RoutineSession.morning) {
        morningTasks.add(item);
      } else {
        eveningTasks.add(item);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add task',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Initialize with smart defaults (first time use)
  Future<void> initializeDefaults() async {
    try {
      isLoading.value = true;
      final today = DateTime.now();
      
      // Create morning routine
      for (final task in defaultMorningRoutine) {
        final item = PlanItem(
          id: '${today.millisecondsSinceEpoch}_morning_${task['order']}',
          title: task['title'],
          date: today,
          time: task['time'],
          category: 'Routine',
        );
        await _planRepo.addPlanItem(item);
      }
      
      // Create evening routine
      for (final task in defaultEveningRoutine) {
        final item = PlanItem(
          id: '${today.millisecondsSinceEpoch}_evening_${task['order']}',
          title: task['title'],
          date: today,
          time: task['time'],
          category: 'Routine',
        );
        await _planRepo.addPlanItem(item);
      }
      
      await _loadRoutines();
      
      Get.snackbar(
        'Routines Created',
        'Default morning & evening routines added',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create defaults',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await _loadRoutines();
  }
}


