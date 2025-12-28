import 'package:get/get.dart';
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

  Future<void> _loadPlanItems() async {
    isLoading.value = true;
    try {
      planItems.value = await _planRepo.getPlanItems();
      todayPlans.value = await _planService.getTodayPlans();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPlanItem(PlanItem item) async {
    await _planService.addPlanItem(item);
    await _loadPlanItems();
  }

  Future<void> markCompleted(String id) async {
    await _planService.markCompleted(id);
    await _loadPlanItems();
  }

  Future<void> updatePlanItem(PlanItem item) async {
    await _planRepo.updatePlanItem(item);
    await _loadPlanItems();
  }

  Future<void> deletePlanItem(String id) async {
    await _planRepo.deletePlanItem(id);
    await _loadPlanItems();
  }

  List<PlanItem> getPlansForDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return planItems.where((item) {
      final itemDate = DateTime(item.date.year, item.date.month, item.date.day);
      return itemDate.isAtSameMomentAs(dateOnly);
    }).toList();
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
