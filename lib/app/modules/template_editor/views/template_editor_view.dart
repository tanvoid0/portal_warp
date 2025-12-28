import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/template_editor_controller.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../data/models/focus_area.dart';
import '../../../routes/app_routes.dart' show Routes;

class TemplateEditorView extends GetView<TemplateEditorController> {
  const TemplateEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing.value ? 'Edit Template' : 'New Template'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: controller.saveTemplate,
          ),
        ],
      ),
      body: Obx(() => SingleChildScrollView(
            padding: const EdgeInsets.all(DesignTokens.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                TextField(
                  controller: TextEditingController(text: controller.template.value.title),
                  onChanged: controller.updateTitle,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    hintText: 'e.g., Fold and file 10 shirts',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: DesignTokens.spacingXL),

                // Focus Area
                Text('Focus Area', style: DesignTokens.titleStyle),
                const SizedBox(height: DesignTokens.spacingM),
                Obx(() => Wrap(
                  spacing: DesignTokens.spacingM,
                  children: FocusArea.values.map((area) {
                    final isSelected = controller.template.value.focusAreaId == area;
                    return FilterChip(
                      label: Text(area.displayName),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) controller.updateFocusArea(area);
                      },
                    );
                  }).toList(),
                )),

                const SizedBox(height: DesignTokens.spacingXL),

                // Duration Bucket
                Text('Duration (minutes)', style: DesignTokens.titleStyle),
                const SizedBox(height: DesignTokens.spacingM),
                Obx(() => SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 2, label: Text('2 min')),
                    ButtonSegment(value: 10, label: Text('10 min')),
                    ButtonSegment(value: 30, label: Text('30 min')),
                  ],
                  selected: {controller.template.value.durationBucket},
                  onSelectionChanged: (Set<int> newSelection) {
                    if (newSelection.isNotEmpty) {
                      controller.updateDurationBucket(newSelection.first);
                    }
                  },
                )),

                const SizedBox(height: DesignTokens.spacingXL),

                // Difficulty
                Text('Difficulty (1-5)', style: DesignTokens.titleStyle),
                const SizedBox(height: DesignTokens.spacingM),
                Obx(() => Slider(
                  value: controller.template.value.difficulty.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '${controller.template.value.difficulty}',
                  onChanged: (value) => controller.updateDifficulty(value.toInt()),
                )),

                const SizedBox(height: DesignTokens.spacingXL),

                // Cooldown Days
                Text('Cooldown Days', style: DesignTokens.titleStyle),
                const SizedBox(height: DesignTokens.spacingM),
                Obx(() => Slider(
                  value: controller.template.value.cooldownDays.toDouble(),
                  min: 0,
                  max: 7,
                  divisions: 7,
                  label: '${controller.template.value.cooldownDays}',
                  onChanged: (value) => controller.updateCooldownDays(value.toInt()),
                )),

                const SizedBox(height: DesignTokens.spacingXL),

                // Instructions
                TextField(
                  controller: TextEditingController(
                    text: controller.template.value.instructions,
                  ),
                  onChanged: controller.updateInstructions,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Instructions',
                    hintText: 'Detailed instructions for this quest...',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: DesignTokens.spacingXXL),
              ],
            ),
          )),
    );
  }
}
