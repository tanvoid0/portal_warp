import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_navigation_controller.dart';
import '../../core/theme/design_tokens.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _buildBody()),
      bottomNavigationBar: Obx(() => _buildBottomNavBar()),
    );
  }

  Widget _buildBody() {
    // This will be handled by GetX routing
    return const SizedBox.shrink();
  }

  Widget _buildBottomNavBar() {
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
      child: BottomNavigationBar(
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
      ),
    );
  }
}

