import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/main_navigation/main_navigation_controller.dart';
import '../theme/design_tokens.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<MainNavigationController>()) {
      return const SizedBox.shrink();
    }

    final controller = Get.find<MainNavigationController>();
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF6B6B), // Coral color
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: DesignTokens.captionStyle.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: DesignTokens.captionStyle,
        items: controller.navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      )),
    );
  }
}

