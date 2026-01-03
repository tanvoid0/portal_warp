import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cheatsheet_controller.dart';
import '../../../core/widgets/modern_app_bar.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../modules/main_navigation/main_navigation_controller.dart';
import '../../../routes/app_routes.dart';
import 'cheatsheet_category_detail_view.dart';

class CheatsheetView extends GetView<CheatsheetController> {
  const CheatsheetView({super.key});

  @override
  Widget build(BuildContext context) {
    // Update navigation index if MainNavigationController exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MainNavigationController>()) {
        Get.find<MainNavigationController>().updateCurrentIndex(Routes.cheatsheet);
      }
    });

    return Scaffold(
      appBar: ModernAppBar(
        title: 'Cheatsheets',
        leading: null,
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(DesignTokens.spacingL),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = controller.cheatsheetCategories[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
                    child: _CheatsheetCategoryCard(category: category),
                  );
                },
                childCount: controller.cheatsheetCategories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheatsheetCategoryCard extends StatelessWidget {
  final CheatsheetCategory category;

  const _CheatsheetCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed('${Routes.cheatsheet}/${category.id}');
        },
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(category.color).withOpacity(0.1),
                Color(category.color).withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingM),
                decoration: BoxDecoration(
                  color: Color(category.color).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: Icon(
                  category.icon,
                  color: Color(category.color),
                  size: 32,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          category.title,
                          style: DesignTokens.titleStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: DesignTokens.spacingS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(DesignTokens.spacingS),
                          ),
                          child: Text(
                            'Template',
                            style: DesignTokens.captionStyle.copyWith(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacingXS),
                    Text(
                      '${category.description} • Import to ${category.type == CheatsheetType.drawer ? "Wardrobe" : "Shopping"}',
                      style: DesignTokens.bodyStyle.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

