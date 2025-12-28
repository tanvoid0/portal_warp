import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/today/bindings/today_binding.dart';
import '../modules/today/views/today_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/templates/bindings/templates_binding.dart';
import '../modules/templates/views/templates_view.dart';
import '../modules/template_editor/bindings/template_editor_binding.dart';
import '../modules/template_editor/views/template_editor_view.dart';
import '../modules/drawer/bindings/drawer_binding.dart';
import '../modules/drawer/views/drawer_view.dart';
import '../modules/shopping/bindings/shopping_binding.dart';
import '../modules/shopping/views/shopping_view.dart';
import '../modules/planning/bindings/planning_binding.dart';
import '../modules/planning/views/planning_view.dart';
import '../modules/review/bindings/review_binding.dart';
import '../modules/review/views/review_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.today,
      page: () => const TodayView(),
      binding: TodayBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.templates,
      page: () => const TemplatesView(),
      binding: TemplatesBinding(),
    ),
    GetPage(
      name: Routes.templateEditor,
      page: () => const TemplateEditorView(),
      binding: TemplateEditorBinding(),
    ),
    GetPage(
      name: Routes.drawer,
      page: () => const DrawerView(),
      binding: DrawerBinding(),
    ),
    GetPage(
      name: Routes.shopping,
      page: () => const ShoppingView(),
      binding: ShoppingBinding(),
    ),
    GetPage(
      name: Routes.planning,
      page: () => const PlanningView(),
      binding: PlanningBinding(),
    ),
    GetPage(
      name: Routes.review,
      page: () => const ReviewView(),
      binding: ReviewBinding(),
    ),
  ];
}
