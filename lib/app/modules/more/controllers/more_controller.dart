import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class MoreController extends GetxController {
  final List<MenuItem> menuItems = [
    MenuItem(
      title: 'Cheatsheet',
      description: 'Browse templates and import items',
      icon: Icons.menu_book,
      route: Routes.cheatsheet,
      color: 0xFF6B6BFF,
    ),
    MenuItem(
      title: 'Settings',
      description: 'App preferences and configuration',
      icon: Icons.settings,
      route: Routes.settings,
      color: 0xFF757575,
    ),
    MenuItem(
      title: 'Templates',
      description: 'Manage quest and plan templates',
      icon: Icons.description,
      route: Routes.templates,
      color: 0xFFFF6B6B,
    ),
    MenuItem(
      title: 'Weekly Review',
      description: 'Review your progress and achievements',
      icon: Icons.assessment,
      route: Routes.review,
      color: 0xFF6BFFB3,
    ),
  ];
}

class MenuItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final int color;

  MenuItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.color,
  });
}

