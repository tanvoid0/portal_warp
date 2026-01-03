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
      label: 'Items',
      route: Routes.items,
    ),
    NavItem(
      icon: Icons.calendar_today,
      label: 'Planning',
      route: Routes.planning,
    ),
    NavItem(
      icon: Icons.more_horiz,
      label: 'More',
      route: Routes.more,
    ),
  ];

  void changePage(int index) {
    if (index != currentIndex.value) {
      currentIndex.value = index;
      // Use offNamed to replace the route instead of pushing, preventing back button
      Get.offNamed(navItems[index].route);
    }
  }

  void updateCurrentIndex(String route) {
    // Map child routes to parent navigation items
    String mappedRoute = route;
    if (route == Routes.inventory || route == Routes.inventoryWardrobe || route == Routes.shopping) {
      mappedRoute = Routes.items;
    } else if (route == Routes.cheatsheet || route == Routes.settings || 
               route == Routes.templates || route == Routes.review) {
      mappedRoute = Routes.more;
    }
    
    final index = navItems.indexWhere((item) => item.route == mappedRoute);
    if (index != -1) {
      currentIndex.value = index;
    }
  }

  void navigateToRoute(String route) {
    final index = navItems.indexWhere((item) => item.route == route);
    if (index != -1) {
      currentIndex.value = index;
      // Use offNamed to replace the route for main navigation tabs
      Get.offNamed(route);
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

