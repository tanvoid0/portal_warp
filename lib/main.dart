import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/services/api_client.dart';
import 'app/modules/main_navigation/main_navigation_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API client
  await Get.putAsync<ApiClient>(() => ApiClient().init());
  
  // Initialize navigation controller permanently
  MainNavigationBinding().dependencies();
  
  // Check auth status
  final apiClient = Get.find<ApiClient>();
  final isLoggedIn = await apiClient.isLoggedIn();
  
  runApp(PortalWarpApp(isLoggedIn: isLoggedIn));
}

class PortalWarpApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const PortalWarpApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Portal Warp',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? Routes.today : Routes.login,
      getPages: AppPages.routes,
    );
  }
}
