import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../../data/models/focus_area.dart';
import '../../../data/models/energy_level.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../modules/main_navigation/main_navigation_controller.dart';
import '../../../routes/app_routes.dart' show Routes;

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Update navigation index if MainNavigationController exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MainNavigationController>()) {
        Get.find<MainNavigationController>().updateCurrentIndex(Routes.settings);
      }
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final prefs = controller.userPrefs.value;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Focus Areas
              Text('Focus Areas', style: DesignTokens.titleStyle),
              const SizedBox(height: DesignTokens.spacingM),
              ...FocusArea.values.map((area) {
                final isEnabled = prefs.enabledFocusAreas[area] ?? true;
                return SwitchListTile(
                  title: Text(area.displayName),
                  value: isEnabled,
                  onChanged: (_) => controller.toggleFocusArea(area),
                );
              }),
              
              const SizedBox(height: DesignTokens.spacingXL),
              
              // Time Budget
              Text('Time Budget', style: DesignTokens.titleStyle),
              const SizedBox(height: DesignTokens.spacingM),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 10, label: Text('10 min')),
                  ButtonSegment(value: 20, label: Text('20 min')),
                  ButtonSegment(value: 40, label: Text('40 min')),
                ],
                selected: {prefs.timeBudgetMinutes},
                onSelectionChanged: (Set<int> newSelection) {
                  controller.setTimeBudget(newSelection.first);
                },
              ),
              
              const SizedBox(height: DesignTokens.spacingXL),
              
              // Difficulty Cap
              Text('Difficulty Cap', style: DesignTokens.titleStyle),
              const SizedBox(height: DesignTokens.spacingM),
              Slider(
                value: prefs.difficultyCap.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: '${prefs.difficultyCap}',
                onChanged: (value) => controller.setDifficultyCap(value.toInt()),
              ),
              
              const SizedBox(height: DesignTokens.spacingXL),
              
              // Default Energy
              Text('Default Energy Level', style: DesignTokens.titleStyle),
              const SizedBox(height: DesignTokens.spacingM),
              SegmentedButton<EnergyLevel>(
                segments: EnergyLevel.values.map((level) {
                  return ButtonSegment(
                    value: level,
                    label: Text(level.displayName),
                  );
                }).toList(),
                selected: {prefs.defaultEnergy},
                onSelectionChanged: (Set<EnergyLevel> newSelection) {
                  controller.setDefaultEnergy(newSelection.first);
                },
              ),
              
              const SizedBox(height: DesignTokens.spacingXL),
              
              // Weekly Targets
              Text('Weekly Targets', style: DesignTokens.titleStyle),
              const SizedBox(height: DesignTokens.spacingM),
              ...FocusArea.values.map((area) {
                final target = prefs.weeklyTarget[area] ?? 0;
                return ListTile(
                  title: Text(area.displayName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: target > 0
                            ? () => controller.setWeeklyTarget(area, target - 1)
                            : null,
                      ),
                      Text('$target', style: DesignTokens.titleStyle),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => controller.setWeeklyTarget(area, target + 1),
                      ),
                    ],
                  ),
                );
              }),
              
              const SizedBox(height: DesignTokens.spacingXL),
              
              // Quick Links
              Text('Quick Links', style: DesignTokens.titleStyle),
              const SizedBox(height: DesignTokens.spacingM),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Quest Templates'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.toNamed(Routes.templates),
              ),
              ListTile(
                leading: const Icon(Icons.assessment),
                title: const Text('Weekly Review'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.toNamed(Routes.review),
              ),
            ],
          ),
        );
      }),
    );
  }
}
