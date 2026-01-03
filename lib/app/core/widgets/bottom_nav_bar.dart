import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/main_navigation/main_navigation_controller.dart';
import 'modern_bottom_nav_bar.dart';

/// Bottom navigation bar - now uses modern design
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModernBottomNavBar();
  }
}

