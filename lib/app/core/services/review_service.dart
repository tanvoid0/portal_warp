import '../../data/models/quest_instance.dart';
import '../../data/models/weekly_review.dart';
import '../../data/models/focus_area.dart';
import '../../data/repositories/quests_repository.dart';
import '../../data/repositories/templates_repository.dart';

class ReviewService {
  final QuestsRepository _questsRepo;
  final TemplatesRepository _templatesRepo;

  ReviewService(this._questsRepo, this._templatesRepo);

  Future<WeeklyReview> generateWeeklyReview(DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 7));
    
    // Get all quest instances for the week
    final instances = await _questsRepo.getQuestInstancesByDateRange(
      weekStart,
      weekEnd,
    );

    // Calculate completion stats per focus area
    final completionStats = <FocusArea, double>{};
    final areaStats = <FocusArea, Map<String, int>>{};
    
    // Initialize all focus areas
    for (final area in FocusArea.values) {
      areaStats[area] = {'completed': 0, 'total': 0};
    }
    
    // Group instances by focus area and calculate stats
    for (final instance in instances) {
      final template = await _templatesRepo.getTemplateById(instance.templateId);
      if (template != null) {
        final area = template.focusAreaId;
        final stats = areaStats[area]!;
        stats['total'] = stats['total']! + 1;
        if (instance.status.name == 'done') {
          stats['completed'] = stats['completed']! + 1;
        }
      }
    }
    
    // Calculate completion rates
    for (final entry in areaStats.entries) {
      final area = entry.key;
      final stats = entry.value;
      final total = stats['total']!;
      final completed = stats['completed']!;
      
      if (total > 0) {
        completionStats[area] = completed / total;
      } else {
        // If no quests for this area, set to 0
        completionStats[area] = 0.0;
      }
    }

    // Detect avoided areas (areas with < 30% completion)
    final avoidedAreas = <FocusArea>[];
    completionStats.forEach((area, rate) {
      if (rate < 0.3) {
        avoidedAreas.add(area);
      }
    });

    // Generate exactly one adjustment suggestion
    final adjustment = _generateAdjustment(completionStats, avoidedAreas, instances);

    return WeeklyReview(
      weekStart: weekStart,
      completionStats: completionStats,
      avoidedAreas: avoidedAreas,
      oneAdjustment: adjustment,
    );
  }

  String _generateAdjustment(
    Map<FocusArea, double> stats,
    List<FocusArea> avoided,
    List<QuestInstance> instances,
  ) {
    // Rule-based adjustment generation (no AI)
    
    if (avoided.isNotEmpty) {
      return "Try reducing difficulty for ${avoided.first.displayName} quests this week. Start with 2-minute quests to build momentum.";
    }

    final totalCompleted = instances.where((i) => i.status.name == 'done').length;
    final totalQuests = instances.length;

    if (totalQuests > 0) {
      final completionRate = totalCompleted / totalQuests;
      
      if (completionRate < 0.5) {
        return "You completed less than half your quests. Try setting your energy level to 'Low' and focus on 2-minute quests to build consistency.";
      } else if (completionRate >= 0.8) {
        return "Great week! Consider increasing your difficulty cap by 1 to challenge yourself more.";
      } else {
        return "You're doing well! Try adding one 30-minute quest per week when your energy is high.";
      }
    }

    return "Start by completing at least one quest per day to build your streak.";
  }
}

