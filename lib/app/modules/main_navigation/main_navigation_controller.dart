import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class MainNavigationController extends GetxController {
  final currentIndex = 0.obs;

  final List<NavItem> navItems = [
    NavItem(
      icon: Icons.today,
      label: 'Today',
      route: Routes.today,
    ),
    NavItem(
      icon: Icons.inventory_2,
      label: 'Drawer',
      route: Routes.drawer,
    ),
    NavItem(
      icon: Icons.shopping_cart,
      label: 'Shopping',
      route: Routes.shopping,
    ),
    NavItem(
      icon: Icons.calendar_today,
      label: 'Planning',
      route: Routes.planning,
    ),
    NavItem(
      icon: Icons.settings,
      label: 'Settings',
      route: Routes.settings,
    ),
  ];

  void changePage(int index) {
    if (index != currentIndex.value) {
      currentIndex.value = index;
      // Use toNamed instead of offNamed to keep navigation stack
      Get.toNamed(navItems[index].route);
    }
  }

  void updateCurrentIndex(String route) {
    final index = navItems.indexWhere((item) => item.route == route);
    if (index != -1) {
      currentIndex.value = index;
    }
  }

  void navigateToRoute(String route) {
    final index = navItems.indexWhere((item) => item.route == route);
    if (index != -1) {
      currentIndex.value = index;
      Get.toNamed(route);
    }
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final String route;

  NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

