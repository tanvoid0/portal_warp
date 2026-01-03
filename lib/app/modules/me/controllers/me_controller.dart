import 'package:get/get.dart';
import '../../../data/repositories/prefs_repository.dart';
import '../../../data/repositories/quests_repository.dart';
import '../../../core/services/xp_service.dart';
import '../../../routes/app_routes.dart';

/// Menu item for the Me screen
class MeMenuItem {
  final String title;
  final String description;
  final int iconCodePoint;
  final String fontFamily;
  final int color;
  final String route;

  MeMenuItem({
    required this.title,
    required this.description,
    required this.iconCodePoint,
    this.fontFamily = 'MaterialIcons',
    required this.color,
    required this.route,
  });
}

/// Controller for the "Me" view - personal settings & progress
class MeController extends GetxController {
  final PrefsRepository _prefsRepo = PrefsRepository();
  final QuestsRepository _questsRepo = QuestsRepository();
  late final XPService _xpService;

  // Observables
  final isLoading = true.obs;
  final streak = 0.obs;
  final weeklyCompletion = <int>[].obs; // Last 7 days completion count
  final totalTasksCompleted = 0.obs;

  // Menu items for the Me screen
  final List<MeMenuItem> menuItems = [
    MeMenuItem(
      title: 'Cheatsheet',
      description: 'Quick reference guides',
      iconCodePoint: 0xe86f, // Icons.menu_book
      color: 0xFF6B7FD7,
      route: Routes.cheatsheet,
    ),
    MeMenuItem(
      title: 'Templates',
      description: 'Reusable task templates',
      iconCodePoint: 0xe14d, // Icons.copy_all
      color: 0xFF7FD76B,
      route: Routes.templates,
    ),
    MeMenuItem(
      title: 'Weekly Review',
      description: 'Reflect on your progress',
      iconCodePoint: 0xe8b8, // Icons.analytics
      color: 0xFFD76B7F,
      route: Routes.review,
    ),
    MeMenuItem(
      title: 'Settings',
      description: 'App preferences',
      iconCodePoint: 0xe8b8, // Icons.settings
      color: 0xFF9E9E9E,
      route: Routes.settings,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _xpService = XPService(_questsRepo);
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    isLoading.value = true;
    try {
      streak.value = await _xpService.getStreak();
      
      // Calculate weekly completion (simple implementation)
      // In production, this would query actual completion data
      weeklyCompletion.value = await _calculateWeeklyCompletion();
    } catch (e) {
      streak.value = 0;
      weeklyCompletion.value = [0, 0, 0, 0, 0, 0, 0];
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<int>> _calculateWeeklyCompletion() async {
    // Placeholder - would query actual data in production
    // Returns completion count for last 7 days
    try {
      final quests = await _questsRepo.getRecentQuests(days: 7);
      final now = DateTime.now();
      final result = <int>[];
      
      for (var i = 6; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        final dayStart = DateTime(day.year, day.month, day.day);
        final dayEnd = dayStart.add(const Duration(days: 1));
        
        final count = quests.where((q) =>
          q.scheduledDate.isAfter(dayStart) &&
          q.scheduledDate.isBefore(dayEnd) &&
          q.status.name == 'done'
        ).length;
        
        result.add(count);
      }
      
      totalTasksCompleted.value = result.fold(0, (a, b) => a + b);
      return result;
    } catch (e) {
      return [0, 0, 0, 0, 0, 0, 0];
    }
  }

  /// Get streak message
  String get streakMessage {
    if (streak.value == 0) {
      return 'Start your streak today!';
    } else if (streak.value == 1) {
      return '1 day streak - keep it going!';
    } else {
      return '${streak.value} day streak!';
    }
  }

  /// Navigate to a menu item
  void navigateTo(String route) {
    Get.toNamed(route);
  }

  Future<void> refresh() async {
    await _loadProgress();
  }
}


