import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/today/bindings/today_binding.dart';
import '../modules/today/views/today_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/templates/bindings/templates_binding.dart';
import '../modules/templates/views/templates_view.dart';
import '../modules/template_editor/bindings/template_editor_binding.dart';
import '../modules/template_editor/views/template_editor_view.dart';
import '../modules/inventory/bindings/inventory_binding.dart';
import '../modules/inventory/views/inventory_view.dart';
import '../modules/inventory/wardrobe/bindings/wardrobe_binding.dart';
import '../modules/inventory/wardrobe/views/wardrobe_view.dart';
import '../modules/shopping/bindings/shopping_binding.dart';
import '../modules/shopping/views/shopping_view.dart';
import '../modules/planning/bindings/planning_binding.dart';
import '../modules/planning/views/planning_view.dart';
import '../modules/cheatsheet/bindings/cheatsheet_binding.dart';
import '../modules/cheatsheet/views/cheatsheet_view.dart';
import '../modules/cheatsheet/views/cheatsheet_category_detail_view.dart';
import '../modules/review/bindings/review_binding.dart';
import '../modules/review/views/review_view.dart';
import '../modules/items/bindings/items_binding.dart';
import '../modules/items/views/items_view.dart';
import '../modules/more/bindings/more_binding.dart';
import '../modules/more/views/more_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
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
      name: Routes.cheatsheet,
      page: () => const CheatsheetView(),
      binding: CheatsheetBinding(),
      children: [
        GetPage(
          name: '/:categoryId',
          page: () {
            final categoryId = Get.parameters['categoryId'] ?? '';
            return CheatsheetCategoryDetailView(categoryId: categoryId);
          },
        ),
      ],
    ),
    GetPage(
      name: Routes.inventory,
      page: () => const InventoryView(),
      binding: InventoryBinding(),
      children: [
        GetPage(
          name: '/wardrobe',
          page: () => const WardrobeView(),
          binding: WardrobeBinding(),
        ),
      ],
    ),
    GetPage(
      name: Routes.items,
      page: () => const ItemsView(),
      binding: ItemsBinding(),
    ),
    GetPage(
      name: Routes.more,
      page: () => const MoreView(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: Routes.review,
      page: () => const ReviewView(),
      binding: ReviewBinding(),
    ),
  ];
}
