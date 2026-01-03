import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/modern_app_bar.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../modules/main_navigation/main_navigation_controller.dart';
import '../../../routes/app_routes.dart' show Routes;
import 'settings_focus_areas_section.dart';
import 'settings_priority_section.dart';
import 'settings_quest_config_section.dart';
import 'settings_weekly_targets_section.dart';
import 'settings_quick_links_section.dart';
import 'settings_account_section.dart';
import 'settings_data_management_section.dart';

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
      appBar: const ModernAppBar(
        title: 'Settings',
        leading: null,
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SettingsFocusAreasSection(),
              const SizedBox(height: DesignTokens.spacingL),
              const SettingsPrioritySection(),
              const SizedBox(height: DesignTokens.spacingL),
              const SettingsQuestConfigSection(),
              const SizedBox(height: DesignTokens.spacingL),
              const SettingsWeeklyTargetsSection(),
              const SizedBox(height: DesignTokens.spacingL),
              const SettingsQuickLinksSection(),
              const SizedBox(height: DesignTokens.spacingL),
              const SettingsAccountSection(),
              const SizedBox(height: DesignTokens.spacingL),
              const SettingsDataManagementSection(),
              const SizedBox(height: DesignTokens.spacingXL),
            ],
          ),
        );
      }),
    );
  }
}
