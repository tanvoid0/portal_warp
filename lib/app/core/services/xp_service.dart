import '../../data/models/quest_template.dart';
import '../../data/repositories/quests_repository.dart';
import 'dart:math' as math;

class XPService {
  final QuestsRepository _questsRepo;

  XPService(this._questsRepo);

  // Calculate XP based on quest difficulty and duration
  int calculateXP(QuestTemplate template) {
    // Base XP from difficulty (1-5) = 10-50 XP
    final baseXP = template.difficulty * 10;
    
    // Duration multiplier: 2min = 1x, 10min = 1.5x, 30min = 2x
    double durationMultiplier = 1.0;
    switch (template.durationBucket) {
      case 2:
        durationMultiplier = 1.0;
        break;
      case 10:
        durationMultiplier = 1.5;
        break;
      case 30:
        durationMultiplier = 2.0;
        break;
    }
    
    return (baseXP * durationMultiplier).round();
  }

  // Get total XP from all completed quests
  Future<int> getTotalXP() async {
    final instances = await _questsRepo.getQuestInstancesByDateRange(
      DateTime.now().subtract(const Duration(days: 365)),
      DateTime.now(),
    );
    
    final total = instances
        .where((instance) => instance.status.name == 'done')
        .fold<int>(0, (sum, instance) => sum + instance.xpAwarded);
    
    return total;
  }

  // Calculate current level based on total XP
  // Level formula: level = sqrt(totalXP / 100)
  int getLevel(int totalXP) {
    if (totalXP <= 0) return 1;
    return math.sqrt(totalXP / 100).floor() + 1;
  }

  // Get XP needed for next level
  int getXPForNextLevel(int currentLevel) {
    return (currentLevel * currentLevel) * 100;
  }

  // Get current level progress (0.0 to 1.0)
  double getLevelProgress(int totalXP, int currentLevel) {
    final xpForCurrentLevel = ((currentLevel - 1) * (currentLevel - 1)) * 100;
    final xpForNextLevel = getXPForNextLevel(currentLevel);
    final xpInCurrentLevel = totalXP - xpForCurrentLevel;
    final xpNeeded = xpForNextLevel - xpForCurrentLevel;
    
    return (xpInCurrentLevel / xpNeeded).clamp(0.0, 1.0);
  }

  // Calculate streak (consecutive days with at least one completed quest)
  Future<int> getStreak() async {
    final today = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      final instances = await _questsRepo.getQuestInstancesByDate(date);
      
      final hasCompleted = instances.any(
        (instance) => instance.status.name == 'done',
      );
      
      if (hasCompleted) {
        streak++;
      } else {
        break; // Streak broken
      }
    }
    
    return streak;
  }
}

