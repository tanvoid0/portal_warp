import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/more_controller.dart';
import '../../../core/widgets/modern_app_bar.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../modules/main_navigation/main_navigation_controller.dart';
import '../../../routes/app_routes.dart';

class MoreView extends GetView<MoreController> {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    // Update navigation index if MainNavigationController exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MainNavigationController>()) {
        Get.find<MainNavigationController>().updateCurrentIndex(Routes.more);
      }
    });

    return Scaffold(
      appBar: ModernAppBar(
        title: 'More',
        leading: null,
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: GridView.builder(
        padding: const EdgeInsets.all(DesignTokens.spacingL),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: DesignTokens.spacingL,
          mainAxisSpacing: DesignTokens.spacingL,
          childAspectRatio: 1.1,
        ),
        itemCount: controller.menuItems.length,
        itemBuilder: (context, index) {
          final item = controller.menuItems[index];
          return _MoreMenuItemCard(
            title: item.title,
            description: item.description,
            icon: item.icon,
            color: Color(item.color),
            onTap: () => Get.toNamed(item.route),
          );
        },
      ),
    );
  }
}

class _MoreMenuItemCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MoreMenuItemCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

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
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingL),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingM),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingM),
              Text(
                title,
                style: DesignTokens.titleStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.spacingXS),
              Text(
                description,
                style: DesignTokens.captionStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

