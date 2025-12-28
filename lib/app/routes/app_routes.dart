abstract class Routes {
  static const today = '/today';
  static const drawer = '/drawer';
  static const shopping = '/shopping';
  static const planning = '/planning';
  static const templates = '/templates';
  static const templateEditor = '/template-editor';
  static const review = '/review';
  static const settings = '/settings';
  static const SETTINGS = '/settings';
  static const TEMPLATES = '/templates';
  static const TEMPLATE_EDITOR = '/template-editor';
  static const DRAWER = '/drawer';
  static const SHOPPING = '/shopping';
  static const PLANNING = '/planning';
  static const REVIEW = '/review';
}

// Alias for compatibility
abstract class AppRoutes {
  static const today = Routes.today;
  static const drawer = Routes.drawer;
  static const shopping = Routes.shopping;
  static const planning = Routes.planning;
  static const templates = Routes.templates;
  static const templateEditor = Routes.templateEditor;
  static const review = Routes.review;
  static const settings = Routes.settings;
}
