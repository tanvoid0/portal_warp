import 'package:freezed_annotation/freezed_annotation.dart';
import 'energy_level.dart';
import 'focus_area.dart';

part 'user_prefs.freezed.dart';
part 'user_prefs.g.dart';

@freezed
class UserPrefs with _$UserPrefs {
  const factory UserPrefs({
    @Default({}) Map<FocusArea, bool> enabledFocusAreas,
    @Default({}) Map<FocusArea, int> priority, // 1-5
    @Default({}) Map<FocusArea, int> weeklyTarget,
    @Default(20) int timeBudgetMinutes, // 10, 20, or 40
    @Default(5) int difficultyCap, // 1-5
    @Default(EnergyLevel.medium) EnergyLevel defaultEnergy,
  }) = _UserPrefs;

  factory UserPrefs.fromJson(Map<String, dynamic> json) =>
      _$UserPrefsFromJson(json);
}

