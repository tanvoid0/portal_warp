import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/plan_item.dart';
import '../../../data/repositories/plan_repository.dart';
import '../../../core/services/plan_service.dart';
import '../../../core/services/cheatsheet_service.dart';

class PlanningController extends GetxController {
  final PlanRepository _planRepo = PlanRepository();
  late final PlanService _planService;

  @override
  void onInit() {
    super.onInit();
    _planService = PlanService(_planRepo);
    _loadPlanItems();
  }

  final planItems = <PlanItem>[].obs;
  final todayPlans = <PlanItem>[].obs;
  final isLoading = true.obs;
  final selectedDate = DateTime.now().obs;

  /// Predefined specialized categories for plan items
  static const List<String> planCategories = [
    'Hygiene',
    'Skincare',
    'Grooming',
    'Chore',
    'Organization',
    'Preparation',
    'Fitness',
    'Work',
    'Social',
    'Meal',
    'Shopping',
    'Health',
    'Learning',
    'Other',
  ];

  Future<void> _loadPlanItems() async {
    isLoading.value = true;
    try {
      planItems.value = await _planRepo.getPlanItems();
      todayPlans.value = await _planService.getTodayPlans();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load plan items: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPlanItem(PlanItem item) async {
    try {
      await _planService.addPlanItem(item);
      await _loadPlanItems();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add plan item: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> markCompleted(String id) async {
    try {
      await _planService.markCompleted(id);
      await _loadPlanItems();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark as completed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> markPending(String id) async {
    try {
      final items = await _planRepo.getPlanItems();
      final item = items.firstWhere((i) => i.id == id);
      await _planRepo.updatePlanItem(
        item.copyWith(status: PlanStatus.pending),
      );
      await _loadPlanItems();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark as pending: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> updatePlanItem(PlanItem item) async {
    try {
      await _planRepo.updatePlanItem(item);
      await _loadPlanItems();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update plan item: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> deletePlanItem(String id) async {
    try {
      await _planRepo.deletePlanItem(id);
      await _loadPlanItems();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete plan item: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  List<PlanItem> getPlansForDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return planItems.where((item) {
      final itemDate = DateTime(item.date.year, item.date.month, item.date.day);
      return itemDate.isAtSameMomentAs(dateOnly);
    }).toList();
  }

  /// Groups plans by time/session (morning, afternoon, evening, or specific time ranges)
  Map<String, List<PlanItem>> getPlansGroupedByTime(DateTime date) {
    final plans = getPlansForDate(date);
    final grouped = <String, List<PlanItem>>{};

    for (final plan in plans) {
      final session = _getTimeSession(plan);
      grouped.putIfAbsent(session, () => []).add(plan);
    }

    // Sort items within each group by time
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) {
        final timeA = _parseTime(a.time);
        final timeB = _parseTime(b.time);
        if (timeA == null && timeB == null) return 0;
        if (timeA == null) return 1;
        if (timeB == null) return -1;
        return timeA.compareTo(timeB);
      });
    }

    return grouped;
  }

  /// Determines the time session for a plan item (ONLY uses time field, not category)
  /// Categories are separate labels like "Hygiene", "Skincare", "Chore", etc.
  String _getTimeSession(PlanItem plan) {
    final time = plan.time;
    
    // If no time field, return Unscheduled
    if (time == null || time.isEmpty) {
      return 'Unscheduled';
    }
    
    final lowerTime = time.toLowerCase().trim();

    // Check for session keywords in time field only (check longer phrases first)
    if (lowerTime.contains('late night')) return 'Late Night';
    if (lowerTime.contains('morning')) return 'Morning';
    if (lowerTime.contains('afternoon')) return 'Afternoon';
    if (lowerTime.contains('evening')) return 'Evening';
    if (lowerTime.contains('night')) return 'Night';

    // Try to parse as time (e.g., "9:00 AM", "10:30 PM", "9am-10am")
    final parsedTime = _parseTime(time);
    if (parsedTime != null) {
      final hour = parsedTime.hour;
      if (hour >= 5 && hour < 12) return 'Morning';
      if (hour >= 12 && hour < 17) return 'Afternoon';
      if (hour >= 17 && hour < 21) return 'Evening';
      if (hour >= 21 || hour < 5) return 'Night';
    }

    // Check for time ranges (e.g., "9am-10am")
    final rangeMatch = RegExp(r'(\d{1,2})\s*(am|pm|:)?').firstMatch(lowerTime);
    if (rangeMatch != null) {
      final hourStr = rangeMatch.group(1);
      final period = rangeMatch.group(2) ?? '';
      if (hourStr != null) {
        var hour = int.tryParse(hourStr) ?? 0;
        if (period.contains('pm') && hour != 12) hour += 12;
        if (period.contains('am') && hour == 12) hour = 0;
        
        if (hour >= 5 && hour < 12) return 'Morning';
        if (hour >= 12 && hour < 17) return 'Afternoon';
        if (hour >= 17 && hour < 21) return 'Evening';
        if (hour >= 21 || hour < 5) return 'Night';
      }
    }

    // If it looks like a time range, try to extract the start time
    if (lowerTime.contains('-')) {
      final parts = lowerTime.split('-');
      if (parts.isNotEmpty) {
        // Recursively check the start time
        final startTime = parts[0].trim();
        final tempPlan = plan.copyWith(time: startTime);
        return _getTimeSession(tempPlan);
      }
    }

    // Default to Unscheduled if we can't determine the session
    return 'Unscheduled';
  }

  /// Parses a time string to DateTime (time only)
  DateTime? _parseTime(String? time) {
    if (time == null || time.isEmpty) return null;

    try {
      // Try parsing formats like "9:00 AM", "10:30 PM", "9am", "10pm"
      final cleanTime = time.trim().toLowerCase();
      
      // Match patterns like "9:00 AM", "10:30 PM"
      var match = RegExp(r'(\d{1,2}):(\d{2})\s*(am|pm)').firstMatch(cleanTime);
      if (match != null) {
        var hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        final period = match.group(3)!;
        
        if (period == 'pm' && hour != 12) hour += 12;
        if (period == 'am' && hour == 12) hour = 0;
        
        return DateTime(2000, 1, 1, hour, minute);
      }

      // Match patterns like "9 AM", "10 PM", "9am", "10pm"
      match = RegExp(r'(\d{1,2})\s*(am|pm)').firstMatch(cleanTime);
      if (match != null) {
        var hour = int.parse(match.group(1)!);
        final period = match.group(2)!;
        
        if (period == 'pm' && hour != 12) hour += 12;
        if (period == 'am' && hour == 12) hour = 0;
        
        return DateTime(2000, 1, 1, hour, 0);
      }

      // Match patterns like "9:00" (24-hour format)
      match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(cleanTime);
      if (match != null) {
        final hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        return DateTime(2000, 1, 1, hour, minute);
      }
    } catch (e) {
      // If parsing fails, return null
    }

    return null;
  }

  /// Gets the ordered list of session names for display
  List<String> getSessionOrder() {
    return ['Morning', 'Afternoon', 'Evening', 'Night', 'Late Night', 'Unscheduled'];
  }

  /// Import daily checklist items from cheatsheet for selected date
  Future<void> importDailyChecklist() async {
    // Clear existing plan items for the selected date first
    final existingPlans = await _planRepo.getPlanItems();
    final plansForDate = existingPlans.where((p) {
      final planDate = DateTime(p.date.year, p.date.month, p.date.day);
      final selected = DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day);
      return planDate.isAtSameMomentAs(selected);
    }).toList();
    
    // Delete existing plans for this date
    for (var plan in plansForDate) {
      await _planRepo.deletePlanItem(plan.id);
    }
    
    // Load fresh data from cheatsheet
    final cheatsheetService = CheatsheetService();
    final checklistItems = await cheatsheetService.getDailyChecklistItems(selectedDate.value);
    for (final item in checklistItems) {
      await _planRepo.addPlanItem(item);
    }
    await _loadPlanItems();
  }
}
