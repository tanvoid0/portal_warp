abstract class Routes {
  static const splash = '/';
  static const login = '/login';
  static const today = '/today';
  static const inventory = '/inventory';
  static const inventoryWardrobe = '/inventory/wardrobe';
  static const shopping = '/shopping';
  static const planning = '/planning';
  static const cheatsheet = '/cheatsheet';
  static const cheatsheetCategory = '/cheatsheet/:categoryId';
  static const templates = '/templates';
  static const templateEditor = '/template-editor';
  static const review = '/review';
  static const settings = '/settings';
  static const items = '/items';
  static const more = '/more';
}

// Alias for compatibility
abstract class AppRoutes {
  static const splash = Routes.splash;
  static const login = Routes.login;
  static const today = Routes.today;
  static const inventory = Routes.inventory;
  static const inventoryWardrobe = Routes.inventoryWardrobe;
  static const shopping = Routes.shopping;
  static const planning = Routes.planning;
  static const cheatsheet = Routes.cheatsheet;
  static const cheatsheetCategory = Routes.cheatsheetCategory;
  static const templates = Routes.templates;
  static const templateEditor = Routes.templateEditor;
  static const review = Routes.review;
  static const settings = Routes.settings;
  static const items = Routes.items;
  static const more = Routes.more;
}
