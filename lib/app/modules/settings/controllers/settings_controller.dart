import 'package:get/get.dart';
import '../../../data/models/user_prefs.dart';
import '../../../data/models/focus_area.dart';
import '../../../data/models/energy_level.dart';
import '../../../data/repositories/prefs_repository.dart';
import '../../../data/repositories/drawer_repository.dart';
import '../../../data/repositories/shopping_repository.dart';
import '../../../data/repositories/plan_repository.dart';
import '../../../data/repositories/templates_repository.dart';
import '../../../core/services/cheatsheet_service.dart';
import '../../../core/services/api_client.dart';
import '../../../data/local/data_clearer.dart';
import '../../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final PrefsRepository _prefsRepo = PrefsRepository();
  final DrawerRepository _drawerRepo = DrawerRepository();
  final ShoppingRepository _shoppingRepo = ShoppingRepository();
  final PlanRepository _planRepo = PlanRepository();
  final TemplatesRepository _templatesRepo = TemplatesRepository();
  
  final userPrefs = const UserPrefs().obs;
  final isLoading = true.obs;
  final isResetting = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    isLoading.value = true;
    userPrefs.value = await _prefsRepo.getPrefs();
    isLoading.value = false;
  }

  Future<void> toggleFocusArea(FocusArea area) async {
    final current = Map<FocusArea, bool>.from(userPrefs.value.enabledFocusAreas);
    current[area] = !(current[area] ?? true);
    userPrefs.value = userPrefs.value.copyWith(enabledFocusAreas: current);
    await _prefsRepo.savePrefs(userPrefs.value);
  }

  Future<void> setTimeBudget(int minutes) async {
    userPrefs.value = userPrefs.value.copyWith(timeBudgetMinutes: minutes);
    await _prefsRepo.savePrefs(userPrefs.value);
  }

  Future<void> setWeeklyTarget(FocusArea area, int target) async {
    final current = Map<FocusArea, int>.from(userPrefs.value.weeklyTarget);
    current[area] = target;
    userPrefs.value = userPrefs.value.copyWith(weeklyTarget: current);
    await _prefsRepo.savePrefs(userPrefs.value);
  }

  Future<void> setDifficultyCap(int cap) async {
    userPrefs.value = userPrefs.value.copyWith(difficultyCap: cap.clamp(1, 5));
    await _prefsRepo.savePrefs(userPrefs.value);
  }

  Future<void> setDefaultEnergy(EnergyLevel energy) async {
    userPrefs.value = userPrefs.value.copyWith(defaultEnergy: energy);
    await _prefsRepo.savePrefs(userPrefs.value);
  }

  Future<void> setPriority(FocusArea area, int priority) async {
    final current = Map<FocusArea, int>.from(userPrefs.value.priority);
    current[area] = priority.clamp(1, 5);
    userPrefs.value = userPrefs.value.copyWith(priority: current);
    await _prefsRepo.savePrefs(userPrefs.value);
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final apiClient = Get.find<ApiClient>();
      await apiClient.logout();
      Get.offAllNamed(Routes.login);
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout');
    }
  }

  /// Reset all data and import starter data from cheatsheet
  Future<void> resetAndImportAll() async {
    isResetting.value = true;
    try {
      // Clear all data files
      await DataClearer.clearAllData();

      // Seed templates if needed
      await _templatesRepo.seedTemplatesIfEmpty();

      // Import starter wardrobe items
      final cheatsheetService = CheatsheetService();
      final starterWardrobe = await cheatsheetService.getStarterWardrobeItems();
      for (final item in starterWardrobe) {
        await _drawerRepo.addDrawerItem(item);
      }

      // Import starter shopping essentials
      final starterShopping = await cheatsheetService.getStarterShoppingEssentials();
      for (final item in starterShopping) {
        await _shoppingRepo.addShoppingItem(item);
      }

      // Import daily checklist for today
      final today = DateTime.now();
      final dailyChecklist = await cheatsheetService.getDailyChecklistItems(today);
      for (final item in dailyChecklist) {
        await _planRepo.addPlanItem(item);
      }
    } finally {
      isResetting.value = false;
    }
  }
}
