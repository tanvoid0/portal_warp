import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/focus_area.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/theme/design_tokens.dart';
import '../controllers/settings_controller.dart';

class SettingsPrioritySection extends GetView<SettingsController> {
  const SettingsPrioritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final prefs = controller.userPrefs.value;
      
      return SectionCard(
        title: 'Focus Area Priority',
        icon: Icons.star,
        subtitle: 'Set priority levels (1-5) for each focus area',
        child: Column(
          children: FocusArea.values.map((area) {
            final priority = prefs.priority[area] ?? 3;
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        area.displayName,
                        style: DesignTokens.bodyStyle,
                      ),
                    ),
                    Text(
                      'Priority: $priority',
                      style: DesignTokens.captionStyle.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: priority.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '$priority',
                  onChanged: (value) {
                    controller.setPriority(area, value.toInt());
                  },
                ),
                const SizedBox(height: DesignTokens.spacingM),
              ],
            );
          }).toList(),
        ),
      );
    });
  }
}

