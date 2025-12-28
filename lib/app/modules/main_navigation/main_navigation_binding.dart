import 'package:get/get.dart';
import 'main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Use permanent: true to keep controller alive across navigation
    Get.put<MainNavigationController>(
      MainNavigationController(),
      permanent: true,
    );
  }
}

