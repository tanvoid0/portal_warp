import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/core/theme/app_theme.dart';
import 'app/modules/main_navigation/main_navigation_binding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize navigation controller permanently
  MainNavigationBinding().dependencies();
  runApp(const PortalWarpApp());
}

class PortalWarpApp extends StatelessWidget {
  const PortalWarpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Portal Warp',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.today,
      getPages: AppPages.routes,
    );
  }
}

