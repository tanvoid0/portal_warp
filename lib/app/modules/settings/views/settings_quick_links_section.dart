import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/settings_list_tile.dart';
import '../../../routes/app_routes.dart' show Routes;

class SettingsQuickLinksSection extends StatelessWidget {
  const SettingsQuickLinksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Quick Links',
      icon: Icons.link,
      child: Column(
        children: [
          SettingsListTile.navigation(
            title: 'Quest Templates',
            leadingIcon: Icons.description,
            onTap: () => Get.toNamed(Routes.templates),
          ),
          SettingsListTile.navigation(
            title: 'Weekly Review',
            leadingIcon: Icons.assessment,
            onTap: () => Get.toNamed(Routes.review),
          ),
        ],
      ),
    );
  }
}

