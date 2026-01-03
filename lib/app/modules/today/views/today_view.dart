import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/today_controller.dart';
import '../../../core/widgets/energy_picker.dart';
import '../../../core/widgets/xp_bar.dart';
import '../../../core/widgets/quest_card.dart';
import '../../../core/widgets/drawer_card.dart';
import '../../../core/widgets/shopping_card.dart';
import '../../../core/widgets/plan_card.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/services/unsplash_service.dart';
import '../../../modules/main_navigation/main_navigation_controller.dart';
import '../../../routes/app_routes.dart' show Routes;

class TodayView extends GetView<TodayController> {
  const TodayView({super.key});

  @override
  Widget build(BuildContext context) {
    // Update navigation index if MainNavigationController exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MainNavigationController>()) {
        Get.find<MainNavigationController>().updateCurrentIndex(Routes.today);
      }
    });
    
    return Scaffold(
      bottomNavigationBar: Get.isRegistered<MainNavigationController>()
          ? const BottomNavBar()
          : null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: DesignTokens.spacingXL),
              // Hero Image
              ClipRRect(
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: UnsplashService.getHeroImageUrlForScreen('today'),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: DesignTokens.questGradient(context),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: DesignTokens.questGradient(context),
                        ),
                      ),
                    ),
                    // Gradient overlay for text readability
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: -0.1, end: 0, duration: 400.ms),
              const SizedBox(height: DesignTokens.spacingXL),
              // Header
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingXL),
                decoration: BoxDecoration(
                  gradient: DesignTokens.questGradient(context),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                  boxShadow: DesignTokens.softShadow(context),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(DesignTokens.spacingS),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: DesignTokens.spacingM),
                              Text(
                                'Portal Warp',
                                style: DesignTokens.headlineStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 28,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: DesignTokens.spacingS),
                          Text(
                            'Your unified lifestyle dashboard',
                            style: DesignTokens.bodyStyle.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.description, color: Colors.white),
                            onPressed: () => Get.toNamed(Routes.templates),
                            tooltip: 'Templates',
                          ),
                        ),
                        const SizedBox(width: DesignTokens.spacingS),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.assessment, color: Colors.white),
                            onPressed: () => Get.toNamed(Routes.review),
                            tooltip: 'Weekly Review',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: -0.1, end: 0, duration: 400.ms),
              const SizedBox(height: DesignTokens.spacingXL),

              // Energy Picker
              EnergyPicker(
                selectedEnergy: controller.energyLevel.value,
                onEnergyChanged: (level) => controller.selectEnergy(level),
              ),
              const SizedBox(height: DesignTokens.spacingXL),

              // XP Bar and Streak
              Obx(() {
                final totalXP = controller.xp.value;
                final currentLevel = controller.level.value;
                final xpForNextLevel = controller.xpService.getXPForNextLevel(currentLevel);
                final xpForCurrentLevel = ((currentLevel - 1) * (currentLevel - 1)) * 100;
                final currentXPInLevel = totalXP - xpForCurrentLevel;
                final xpNeededForNext = xpForNextLevel - xpForCurrentLevel;
                
                return XPBar(
                  currentXP: currentXPInLevel,
                  maxXP: xpNeededForNext,
                );
              }),
              const SizedBox(height: DesignTokens.spacingM),
              Row(
                children: [
                  Text(
                    'Level ${controller.level.value}',
                    style: DesignTokens.titleStyle,
                  ),
                  const Spacer(),
                  Text(
                    '🔥 ${controller.streak.value} day streak',
                    style: DesignTokens.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingXL),

              // Today's Quests
              Text(
                "Today's Quests",
                style: DesignTokens.titleStyle,
              ),
              const SizedBox(height: DesignTokens.spacingL),
              ...controller.todayQuests.map((quest) {
                final template = controller.questTemplates[quest.templateId];
                if (template == null) return const SizedBox.shrink();

                final gradient = controller.getQuestGradient(context,
                  template.focusAreaId.name,
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: DesignTokens.spacingL),
                  child: QuestCard(
                    title: template.title,
                    focusArea: template.focusAreaId.displayName,
                    durationMinutes: template.durationBucket,
                    gradient: gradient,
                    isCompleted: quest.status.name == 'done',
                    xpAwarded: quest.xpAwarded > 0 ? quest.xpAwarded : null,
                    onDone: quest.status.name != 'done' && quest.status.name != 'skip'
                        ? () => controller.completeQuest(quest.id)
                        : null,
                    onSkip: quest.status.name != 'done' && quest.status.name != 'skip'
                        ? () => controller.skipQuest(quest.id)
                        : null,
                  ),
                );
              }),

              // Drawer Status (if clothes quests active)
              if (controller.todayQuests.any((q) {
                final template = controller.questTemplates[q.templateId];
                return template?.focusAreaId.name == 'clothes';
              })) ...[
                const SizedBox(height: DesignTokens.spacingXL),
                DrawerCard(
                  title: 'Drawer Organization',
                  status: '${(controller.drawerStatus['percentage'] ?? 0.0) * 100}% organized',
                  isOrganized: (controller.drawerStatus['percentage'] ?? 0.0) > 0.5,
                ),
              ],

              // Shopping Preview (if cooking quests active)
              if (controller.todayQuests.any((q) {
                final template = controller.questTemplates[q.templateId];
                return template?.focusAreaId.name == 'cooking';
              }) && controller.pendingShopping.isNotEmpty) ...[
                const SizedBox(height: DesignTokens.spacingXL),
                Text(
                  'Shopping List',
                  style: DesignTokens.titleStyle,
                ),
                const SizedBox(height: DesignTokens.spacingL),
                ...controller.pendingShopping.take(3).map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
                    child: ShoppingCard(
                      itemName: item.name,
                      category: item.category,
                      quantity: item.quantity,
                      priority: item.priority,
                      isPurchased: item.status.name == 'purchased',
                    ),
                  );
                }),
              ],

              // Today's Plans
              if (controller.todayPlans.isNotEmpty) ...[
                const SizedBox(height: DesignTokens.spacingXL),
                Text(
                  "Today's Plans",
                  style: DesignTokens.titleStyle,
                ),
                const SizedBox(height: DesignTokens.spacingL),
                ...controller.todayPlans.take(3).map((plan) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
                    child: PlanCard(
                      title: plan.title,
                      time: plan.time,
                      category: plan.category,
                      isCompleted: plan.status.name == 'completed',
                    ),
                  );
                }),
              ],

              const SizedBox(height: DesignTokens.spacingXXL),
            ],
          ),
        );
      }),
    );
  }
}
