import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/templates_controller.dart';
import '../../../core/widgets/gradient_card.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/services/unsplash_service.dart';
import '../../../data/models/quest_template.dart';
import '../../../data/models/focus_area.dart';
import '../../../routes/app_routes.dart' show Routes;

class TemplatesView extends GetView<TemplatesController> {
  const TemplatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quest Templates'),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.templateEditor),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }

        return Column(
          children: [
            // Focus Area Segmented Control
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingL),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: FocusArea.values.map((area) {
                    final isSelected = controller.selectedFocusArea.value == area;
                    return Padding(
                      padding: const EdgeInsets.only(right: DesignTokens.spacingS),
                      child: FilterChip(
                        label: Text(area.displayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            controller.selectedFocusArea.value = area;
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
              child: TextField(
                onChanged: (value) => controller.searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'Search templates...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  ),
                ),
              ),
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Templates List
            Expanded(
              child: controller.filteredTemplates.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                            child: CachedNetworkImage(
                              imageUrl: UnsplashService.getEmptyStateImageUrlForScreen('templates'),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.description_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacingL),
                          Text(
                            'No templates found',
                            style: DesignTokens.titleStyle.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingL,
                      ),
                      itemCount: controller.filteredTemplates.length,
                      itemBuilder: (context, index) {
                        final template = controller.filteredTemplates[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
                          child: _buildTemplateCard(context, template),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTemplateCard(BuildContext context, QuestTemplate template) {
    final gradient = _getGradientForFocusArea(context, template.focusAreaId);

    return GradientCard(
      gradient: gradient,
      onTap: () => Get.toNamed(
        Routes.templateEditor,
        arguments: template,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingM,
                  vertical: DesignTokens.spacingS,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: Text(
                  template.focusAreaId.displayName.toUpperCase(),
                  style: DesignTokens.captionStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: DesignTokens.spacingS),
                  Text(
                    '${template.durationBucket} min',
                    style: DesignTokens.captionStyle.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingL),
          Text(
            template.title,
            style: DesignTokens.titleStyle.copyWith(
              color: Colors.white,
            ),
          ),
          if (template.instructions.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacingM),
            Text(
              template.instructions,
              style: DesignTokens.bodyStyle.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
          const SizedBox(height: DesignTokens.spacingM),
          Row(
            children: [
              Text(
                'Difficulty: ${template.difficulty}/5',
                style: DesignTokens.captionStyle.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingL),
              if (template.cooldownDays > 0)
                Text(
                  'Cooldown: ${template.cooldownDays} days',
                  style: DesignTokens.captionStyle.copyWith(
                    color: Colors.white70,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  LinearGradient _getGradientForFocusArea(BuildContext context, FocusArea area) {
    switch (area) {
      case FocusArea.clothes:
        return DesignTokens.clothesGradient(context);
      case FocusArea.skincare:
        return DesignTokens.skincareGradient(context);
      case FocusArea.fitness:
        return DesignTokens.fitnessGradient(context);
      case FocusArea.cooking:
        return DesignTokens.cookingGradient(context);
    }
  }
}
