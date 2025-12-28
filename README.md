# Portal Warp - Lifestyle Organizer

A unified lifestyle organizer that combines habit-building quests with practical organization tools (drawer management, shopping lists, planning). Built with Flutter + GetX, using a local-first architecture with JSON file storage.

## 🎯 Vision

Portal Warp is a behavior-change engine designed to help you build habits gradually through a "Solo-leveling" quest system. The app integrates multiple aspects of personal development:

- **Quest System**: Daily challenges with adaptive difficulty, XP rewards, and streaks
- **Drawer Organization**: Track clothing items with quantities, units, and organization status
- **Shopping Lists**: Manage shopping with priorities, units, and categories
- **Planning**: Daily/weekly planning with checklists and routines
- **Unified Dashboard**: All features connect - drawer status affects quests, shopping links to cooking quests, planning integrates with daily flow

## 🏗️ Architecture

### Tech Stack

- **Frontend**: Flutter (mobile-first, web companion later)
- **State Management**: GetX (using GetX CLI for project structure)
- **Database**: JSON file storage (local-first, will be replaced with backend/database later)
- **Navigation**: GetX routing
- **Models**: Freezed + json_serializable (immutable, typed)
- **UI**: Material 3 + custom design tokens (gradients, soft shadows, rounded cards)
- **Animations**: flutter_animate (micro-interactions)

### Project Structure

```
lib/
  app/
    routes/          # GetX route definitions
    bindings/        # GetX dependency injection
    data/
      models/        # Freezed models (QuestTemplate, QuestInstance, UserPrefs, 
                      # WeeklyReview, DrawerItem, ShoppingItem, PlanItem, ItemUnit)
      repositories/  # JSON repositories (TemplatesRepo, QuestsRepo, PrefsRepo, 
                      # DrawerRepo, ShoppingRepo, PlanRepo, CheatsheetRepo)
      local/         # JSON storage service + data clearer
    core/
      services/      # Business logic (QuestGenerator, XPService, ReviewService, 
                      # DrawerService, ShoppingService, PlanService, CheatsheetService)
      theme/         # Design tokens, theme configuration
      widgets/       # Reusable components (QuestCard, GradientCard, XPBar, 
                      # EnergyPicker, DrawerCard, ShoppingCard, PlanCard, 
                      # UnitPicker, QuantityCounter)
    modules/
      today/         # Unified dashboard
      drawer/        # Drawer organization
      shopping/      # Shopping lists
      planning/      # Daily/weekly planning
      templates/     # Quest templates management
      template_editor/ # Template editor
      review/        # Weekly review
      settings/      # User settings
      main_navigation/ # Bottom navigation
```

## ✨ Features

### ✅ Implemented

1. **Today Dashboard**
   - Energy level picker (Low/Medium/High)
   - XP bar with level tracking
   - Daily quest generation (3 quests per day)
   - Streak tracking
   - Quick previews: Drawer status, Shopping items, Today's plans

2. **Quest System**
   - Quest templates with focus areas (clothes, skincare, fitness, cooking)
   - Quest instances with status tracking (todo/done/skip)
   - Adaptive difficulty based on completion history
   - XP calculation and leveling
   - Cooldown system to avoid repeats

3. **Drawer Organization**
   - Track clothing items with categories
   - Quantity tracking with units (pieces, pairs, custom units like "t-shirts")
   - Current vs target quantities with progress bars
   - Organization status (organized/unorganized)
   - Import starter wardrobe from cheatsheet
   - Search and filter functionality

4. **Shopping Lists**
   - Shopping items with categories and priorities
   - Quantity tracking with units (kg, bottles, boxes, packs, etc.)
   - Status tracking (pending/purchased)
   - Import shopping essentials and wardrobe buy order
   - Search and filter (show only pending)

5. **Planning**
   - Daily/weekly plan items
   - Time and category support
   - Quantity tracking with units (for tasks like "10 minutes room reset")
   - Status tracking (pending/completed)
   - Date picker for planning
   - Import daily checklist (morning & night routines)

6. **Settings**
   - Toggle focus areas
   - Time budget configuration
   - Weekly targets per area
   - Difficulty cap
   - Default energy level

7. **Templates Management**
   - View quest templates by focus area
   - Create/edit quest templates
   - Link templates to shopping items or drawer actions

8. **Weekly Review**
   - Completion stats by focus area
   - Avoided areas detection
   - One recommended adjustment

9. **Cheatsheet System**
   - Starter wardrobe items (19 items with units and quantities)
   - Shopping essentials (10 items)
   - Wardrobe buy order (9 items with priorities)
   - Daily checklist (morning & night routines with units)
   - Import functionality that clears old data before importing

10. **UI/UX**
    - Modern gradient cards with soft shadows
    - Smooth animations (flutter_animate)
    - Staggered list animations
    - Enhanced dialogs with gradient backgrounds
    - Quantity counters with progress bars
    - Unit pickers with custom unit support
    - Bottom navigation bar
    - Empty states with import options

### 🔄 Data Storage

- **Current**: JSON file storage in app documents directory
- **Future**: Backend/database integration (planned)
- **Data Files**:
  - `drawer_items.json`
  - `shopping_items.json`
  - `plan_items.json`
  - `templates.json`
  - `quest_instances.json`
  - `user_prefs.json`
  - `outfits.json`
  - `cheatsheet_data.json` (local copy)

## 📋 Remaining Work

### High Priority

1. **Quest Generation Logic**
   - [ ] Complete adaptive difficulty algorithm
   - [ ] Better integration with drawer status (suggest organization quests when drawer is <50% organized)
   - [ ] Link cooking quests to shopping items
   - [ ] Consider shopping list when generating cooking quests

2. **Weekly Review**
   - [ ] Complete review service implementation
   - [ ] Calculate completion stats from quest instances
   - [ ] Detect avoided focus areas
   - [ ] Generate exactly one recommended adjustment

3. **Data Persistence**
   - [ ] Replace JSON storage with proper database (Isar or SQLite)
   - [ ] Add data migration support
   - [ ] Implement data backup/restore

4. **Error Handling**
   - [ ] Add proper error handling throughout
   - [ ] User-friendly error messages
   - [ ] Offline mode handling

### Medium Priority

5. **Quest Completion Flow**
   - [ ] Add quest completion animations
   - [ ] Show XP gained on completion
   - [ ] Streak celebration animations
   - [ ] Quest skip functionality with reason

6. **Drawer Organization**
   - [ ] Add photos for drawer items
   - [ ] Outfit planning integration
   - [ ] Category-based organization suggestions

7. **Shopping Integration**
   - [ ] Link shopping items to quests
   - [ ] Auto-suggest shopping items from cooking quests
   - [ ] Shopping list sharing/export

8. **Planning Enhancements**
   - [ ] Recurring plans support
   - [ ] Plan templates
   - [ ] Calendar view

9. **Settings**
   - [ ] Export/import settings
   - [ ] Data reset option
   - [ ] Theme customization (dark mode)

### Low Priority / Future

10. **Backend Integration**
    - [ ] API design
    - [ ] Authentication
    - [ ] Cloud sync
    - [ ] Multi-device support

11. **Advanced Features**
    - [ ] Health integrations (Google Health, Apple Health)
    - [ ] Camera integration for progress photos
    - [ ] Recipe integration with shopping lists
    - [ ] Calendar integration
    - [ ] Notifications/reminders
    - [ ] Social features (optional)

12. **Testing**
    - [ ] Unit tests for services
    - [ ] Widget tests
    - [ ] Integration tests

13. **Documentation**
    - [ ] API documentation
    - [ ] User guide
    - [ ] Developer documentation

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.4 or higher)
- Dart SDK (3.10.4 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd portal_warp
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (Freezed models):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

### First Run

1. The app will start with empty data
2. Go to **Drawer** → Import Starter Wardrobe (from menu or empty state)
3. Go to **Shopping** → Import Shopping Essentials or Wardrobe Buy Order
4. Go to **Planning** → Import Daily Checklist for today's date
5. Go to **Today** → Select energy level and generate quests

### Data Management

- All data is stored locally in JSON files
- Importing from cheatsheet **clears existing data** before importing fresh data
- Use Settings to configure your preferences
- Data files are in: `{app_documents}/portal_warp_data/`

### Building

- **Android**: `flutter build apk`
- **iOS**: `flutter build ios`
- **Web**: `flutter build web`

## 📝 Development Notes

### Code Generation

After modifying Freezed models, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Data Management

- Data is stored in JSON files in the app's documents directory
- Use `DataClearer` service to clear data files
- Import from cheatsheet clears existing data before importing fresh data
- Cheatsheet data is in `assets/cheatsheet_data.json`

### Adding New Features

1. Create model in `lib/app/data/models/` (use Freezed)
2. Create repository in `lib/app/data/repositories/`
3. Create service in `lib/app/core/services/`
4. Create controller in `lib/app/modules/<feature>/controllers/`
5. Create view in `lib/app/modules/<feature>/views/`
6. Add route in `lib/app/routes/app_routes.dart` and `app_pages.dart`
7. Add binding in `lib/app/modules/<feature>/bindings/`

## 🎨 Design System

The app uses a custom design system with:
- **Spacing**: 4, 8, 12, 16, 24, 32px scale
- **Corner Radii**: 16, 24, 32px
- **Gradients**: Feature-specific (quests=coral, drawer=indigo, shopping=mint, planning=amber)
- **Shadows**: Soft shadows with low opacity
- **Typography**: Headline, title, body, caption styles

## 📦 Dependencies

- `get: ^4.6.6` - State management and routing
- `freezed: ^2.4.7` - Immutable data classes
- `json_serializable: ^6.7.1` - JSON serialization
- `flutter_animate: ^4.5.0` - Animations
- `intl: ^0.19.0` - Internationalization
- `path_provider: ^2.1.1` - File system access
- `path: ^1.8.3` - Path manipulation

## 🤝 Contributing

This is a personal project, but suggestions and improvements are welcome!

## 📄 License

[Add your license here]

## 🙏 Acknowledgments

- Built with Flutter
- Uses GetX for state management
- Design inspired by modern lifestyle apps

---

## 📊 Current Status

**Status**: ✅ **Ready for GitHub Push**

### Code Quality
- ✅ No critical errors
- ⚠️ Minor warnings: deprecated `withOpacity` (can be fixed later), unused imports
- ℹ️ Info messages: missing `const` constructors (performance optimization)

### What Works
- ✅ All core features functional
- ✅ Data persistence (JSON storage)
- ✅ UI/UX with animations
- ✅ Cheatsheet import system
- ✅ Unit and quantity tracking
- ✅ Bottom navigation
- ✅ All main screens (Today, Drawer, Shopping, Planning, Settings, Templates, Review)

### Known Issues
- Minor: Deprecated `withOpacity` usage (Flutter 3.27+ recommends `.withValues()`)
- Minor: Some unused imports (can be cleaned up)
- Minor: Missing `const` constructors (performance optimization, not critical)

### Next Steps (for other machine)
1. Fix deprecated `withOpacity` warnings (optional, non-critical)
2. Complete quest generation integration with drawer/shopping
3. Complete weekly review service implementation
4. Add quest completion animations
5. Test on physical devices
6. Consider database migration (Isar/SQLite) for better performance

---

**Ready to push**: Yes ✅ | **Production ready**: Almost (needs testing and polish)
