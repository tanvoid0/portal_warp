# Modern UI Kit - Usage Guide

## Overview
This guide shows how to use the new modern UI components in Portal Warp.

## Components

### 1. ModernStatCard
Beautiful stat display card for dashboard metrics.

```dart
ModernStatCard(
  label: 'Organized Items',
  value: '42',
  icon: Icons.check_circle,
  trend: '+12%',
  isPositiveTrend: true,
  onTap: () => print('Tapped'),
  index: 0, // For staggered animations
)
```

### 2. EmptyStateWidget
Beautiful empty state with icon, message, and optional CTA.

```dart
EmptyStateWidget(
  icon: Icons.inventory_2,
  title: 'No items yet',
  message: 'Get started by adding your first item',
  actionLabel: 'Add Item',
  onAction: () => _addItem(),
)
```

### 3. SkeletonLoader & SkeletonCard
Shimmer effect loaders for content placeholders.

```dart
// Simple loader
SkeletonLoader(
  width: 200,
  height: 20,
  borderRadius: BorderRadius.circular(8),
)

// Card loader
SkeletonCard(height: 100)
```

### 4. ProgressRing
Circular progress indicator with animations.

```dart
ProgressRing(
  progress: 0.75, // 0.0 to 1.0
  size: 70,
  strokeWidth: 6,
  child: Text('75%'), // Optional center content
)
```

### 5. AnimatedButton
Button with loading and success states.

```dart
AnimatedButton(
  label: 'Save',
  icon: Icons.save,
  isLoading: isSaving,
  isSuccess: isSaved,
  onPressed: () => _save(),
)
```

### 6. GlassmorphicCard
Enhanced glassmorphic card with blur effects.

```dart
GlassmorphicCard(
  gradient: LinearGradient(...), // Optional
  blur: 10.0,
  opacity: 0.2,
  onTap: () => _handleTap(),
  child: YourContent(),
  index: 0, // For animations
)
```

### 7. ModernSearchBar
Modern search bar with filters.

```dart
ModernSearchBar(
  controller: searchController,
  hintText: 'Search...',
  onChanged: (value) => _search(value),
  showFilters: true,
  onFilterTap: () => _showFilters(),
)
```

### 8. SectionHeader
Modern section header with optional action.

```dart
SectionHeader(
  title: 'Recent Items',
  actionLabel: 'See All',
  actionIcon: Icons.arrow_forward,
  onAction: () => _seeAll(),
)
```

### 9. ConfirmationDialog
Reusable confirmation dialog for user actions.

```dart
// Simple confirmation
final confirmed = await ConfirmationDialog.show(
  title: 'Delete Item',
  message: 'Are you sure you want to delete this item?',
  confirmLabel: 'Delete',
  isDestructive: true,
);

// Regular confirmation
final confirmed = await ConfirmationDialog.show(
  title: 'Save Changes',
  message: 'Do you want to save your changes?',
  confirmLabel: 'Save',
);
```

### 10. LoadingWidget
Consistent loading state indicator.

```dart
// Full-screen loading
if (isLoading) {
  return const LoadingWidget();
}

// Inline loading
LoadingWidget.inline(
  message: 'Loading...',
  size: 20,
  strokeWidth: 2,
)
```

### 11. SectionCard
Card component for grouping related settings or content.

```dart
SectionCard(
  title: 'Focus Areas',
  icon: Icons.category,
  subtitle: 'Manage your focus areas',
  child: Column(
    children: [
      // Your content here
    ],
  ),
)
```

### 12. CategoryCard
Card component for category navigation.

```dart
CategoryCard(
  title: 'Wardrobe',
  description: 'Manage your clothing items',
  icon: Icons.checkroom,
  route: Routes.wardrobe,
  gradientColors: [
    Colors.blue.withOpacity(0.1),
    Colors.blue.withOpacity(0.05),
  ],
)
```

### 13. SettingsListTile
Reusable list tile for settings patterns.

```dart
// Switch variant
SettingsListTile.switch_(
  title: 'Enable Notifications',
  switchValue: isEnabled,
  onSwitchChanged: (value) => setEnabled(value),
)

// Navigation variant
SettingsListTile.navigation(
  title: 'Account Settings',
  leadingIcon: Icons.account_circle,
  onTap: () => navigateToSettings(),
)

// Custom trailing
SettingsListTile.custom(
  title: 'Storage',
  trailing: Text('2.5 GB'),
  onTap: () => showStorageDetails(),
)
```

## Integration Examples

### Dashboard with Stats
```dart
Column(
  children: [
    SectionHeader(title: 'Overview'),
    GridView.count(
      crossAxisCount: 2,
      children: [
        ModernStatCard(
          label: 'Total Items',
          value: '${items.length}',
          icon: Icons.inventory_2,
          index: 0,
        ),
        ModernStatCard(
          label: 'Organized',
          value: '${organizedCount}',
          icon: Icons.check_circle,
          trend: '+5%',
          isPositiveTrend: true,
          index: 1,
        ),
      ],
    ),
  ],
)
```

### List with Empty State
```dart
if (items.isEmpty)
  EmptyStateWidget(
    icon: Icons.shopping_cart,
    title: 'No items yet',
    message: 'Start by adding your first item',
    actionLabel: 'Add Item',
    onAction: () => _showAddDialog(),
  )
else
  ListView.builder(...)
```

### Loading State
```dart
// Using LoadingWidget
if (isLoading) {
  return const LoadingWidget();
}

// Using SkeletonLoader for content placeholders
if (isLoading)
  ListView.builder(
    itemCount: 5,
    itemBuilder: (context, index) => SkeletonCard(),
  )
else
  ListView.builder(...)
```

### Settings View Pattern
```dart
SingleChildScrollView(
  padding: const EdgeInsets.all(DesignTokens.spacingL),
  child: Column(
    children: [
      SectionCard(
        title: 'Preferences',
        icon: Icons.settings,
        child: Column(
          children: [
            SettingsListTile.switch_(
              title: 'Dark Mode',
              switchValue: isDarkMode,
              onSwitchChanged: (value) => setDarkMode(value),
            ),
            SettingsListTile.navigation(
              title: 'Notifications',
              leadingIcon: Icons.notifications,
              onTap: () => navigateToNotifications(),
            ),
          ],
        ),
      ),
    ],
  ),
)
```

### Confirmation Dialog Pattern
```dart
IconButton(
  icon: const Icon(Icons.delete),
  onPressed: () async {
    final confirmed = await ConfirmationDialog.show(
      title: 'Delete Item',
      message: 'Are you sure you want to delete "${item.name}"?',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (confirmed) {
      deleteItem(item.id);
    }
  },
)
```

## Importing Components

You can import all widgets from a single file:

```dart
import 'package:portal_warp/app/core/widgets/widgets.dart';
```

Or import individual components:

```dart
import 'package:portal_warp/app/core/widgets/confirmation_dialog.dart';
import 'package:portal_warp/app/core/widgets/loading_widget.dart';
```

## Best Practices

1. **Use index for animations**: Pass index to components for staggered animations
2. **Theme-aware**: All components automatically adapt to light/dark themes
3. **Consistent spacing**: Use DesignTokens for spacing
4. **Accessibility**: All components meet WCAG AA contrast requirements
5. **Performance**: Animations are optimized for 60fps

## Component Refactoring Summary

The following improvements have been made to the codebase:

1. **Code Duplication Eliminated:**
   - AlertDialog patterns → `ConfirmationDialog` component
   - Loading states → `LoadingWidget` component
   - Section cards → `SectionCard` component
   - Category cards → `CategoryCard` component

2. **Settings View Refactored:**
   - Reduced from 505 lines to 66 lines
   - Broken into 7 separate section widgets
   - Improved maintainability and readability

3. **New Reusable Components:**
   - `ConfirmationDialog` - Consistent confirmation dialogs
   - `LoadingWidget` - Unified loading states
   - `SectionCard` - Grouped content cards
   - `CategoryCard` - Navigation category cards
   - `SettingsListTile` - Settings UI patterns

4. **Benefits:**
   - ~200+ lines of duplicated code eliminated
   - Consistent UI patterns across the app
   - Easier maintenance and updates
   - Better developer experience

## Next Steps

- Continue using reusable components for new features
- Refactor other large views using the same patterns
- Create more specialized components as needed
- Enhance with more animations and micro-interactions

