import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/theme/design_tokens.dart';
import '../controllers/settings_controller.dart';

class SettingsDataManagementSection extends GetView<SettingsController> {
  const SettingsDataManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SectionCard(
      title: 'Data Management',
      icon: Icons.storage,
      child: ElevatedButton.icon(
        onPressed: controller.isResetting.value
            ? null
            : () async {
                final confirmed = await ConfirmationDialog.show(
                  title: 'Reset & Import All',
                  message: 'This will clear all your data (drawer items, shopping lists, plans, quests) and import starter data from the cheatsheet. This action cannot be undone.\n\nAre you sure you want to continue?',
                  confirmLabel: 'Reset & Import',
                  isDestructive: true,
                );
                
                if (confirmed) {
                  await controller.resetAndImportAll();
                  Get.snackbar(
                    'Success',
                    'All data has been reset and starter data imported.',
                    snackPosition: SnackPosition.TOP,
                  );
                }
              },
        icon: controller.isResetting.value
            ? const LoadingWidget.inline(size: 16, strokeWidth: 2)
            : const Icon(Icons.refresh),
        label: Text(controller.isResetting.value
            ? 'Resetting & Importing...'
            : 'Reset & Import All'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingM,
          ),
        ),
      ),
    ));
  }
}

