import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/focus_area.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/settings_list_tile.dart';
import '../controllers/settings_controller.dart';

class SettingsFocusAreasSection extends GetView<SettingsController> {
  const SettingsFocusAreasSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final prefs = controller.userPrefs.value;
      
      return SectionCard(
        title: 'Focus Areas',
        icon: Icons.category,
        child: Column(
          children: FocusArea.values.map((area) {
            final isEnabled = prefs.enabledFocusAreas[area] ?? true;
            return SettingsListTile.switch_(
              title: area.displayName,
              switchValue: isEnabled,
              onSwitchChanged: (_) => controller.toggleFocusArea(area),
            );
          }).toList(),
        ),
      );
    });
  }
}

