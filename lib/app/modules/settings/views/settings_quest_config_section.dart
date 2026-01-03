import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/energy_level.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/theme/design_tokens.dart';
import '../controllers/settings_controller.dart';

class SettingsQuestConfigSection extends GetView<SettingsController> {
  const SettingsQuestConfigSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final prefs = controller.userPrefs.value;
      
      return SectionCard(
        title: 'Quest Configuration',
        icon: Icons.tune,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Budget
            Text(
              'Time Budget',
              style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
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
            Text(
              'Difficulty Cap',
              style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: prefs.difficultyCap.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: '${prefs.difficultyCap}',
                    onChanged: (value) => controller.setDifficultyCap(value.toInt()),
                  ),
                ),
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(
                    '${prefs.difficultyCap}',
                    style: DesignTokens.titleStyle,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: DesignTokens.spacingXL),
            
            // Default Energy
            Text(
              'Default Energy Level',
              style: DesignTokens.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
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
          ],
        ),
      );
    });
  }
}

