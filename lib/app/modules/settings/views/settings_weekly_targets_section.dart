import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/focus_area.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/theme/design_tokens.dart';
import '../controllers/settings_controller.dart';

class SettingsWeeklyTargetsSection extends GetView<SettingsController> {
  const SettingsWeeklyTargetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final prefs = controller.userPrefs.value;
      
      return SectionCard(
        title: 'Weekly Targets',
        icon: Icons.track_changes,
        subtitle: 'Set weekly goals for each focus area',
        child: Column(
          children: FocusArea.values.map((area) {
            final target = prefs.weeklyTarget[area] ?? 0;
            return ListTile(
              title: Text(area.displayName),
              contentPadding: EdgeInsets.zero,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: target > 0
                        ? () => controller.setWeeklyTarget(area, target - 1)
                        : null,
                  ),
                  Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '$target',
                      style: DesignTokens.titleStyle,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => controller.setWeeklyTarget(area, target + 1),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}

