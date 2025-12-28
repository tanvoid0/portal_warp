import 'package:get/get.dart';
import '../../../data/models/user_prefs.dart';
import '../../../data/models/focus_area.dart';
import '../../../data/models/energy_level.dart';
import '../../../data/repositories/prefs_repository.dart';

class SettingsController extends GetxController {
  final PrefsRepository _prefsRepo = PrefsRepository();
  
  final userPrefs = const UserPrefs().obs;
  final isLoading = true.obs;

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
}
