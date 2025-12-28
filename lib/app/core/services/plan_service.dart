import '../../data/repositories/plan_repository.dart';
import '../../data/models/plan_item.dart';

class PlanService {
  final PlanRepository _planRepo;

  PlanService(this._planRepo);

  Future<List<PlanItem>> getTodayPlans() async {
    return await _planRepo.getTodayPlans();
  }

  Future<List<PlanItem>> getAllPlans() async {
    return await _planRepo.getPlanItems();
  }

  Future<void> addPlanItem(PlanItem item) async {
    await _planRepo.addPlanItem(item);
  }

  Future<void> markCompleted(String id) async {
    await _planRepo.markCompleted(id);
  }

  // Link plans to quests
  Future<void> linkToQuest(String planId, String questId) async {
    final items = await _planRepo.getPlanItems();
    final item = items.firstWhere((i) => i.id == planId);
    await _planRepo.updatePlanItem(
      item.copyWith(linkedQuestId: questId),
    );
  }
}

