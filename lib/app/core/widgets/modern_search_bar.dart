import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';
import '../theme/app_theme.dart';

/// Modern search bar with filters and suggestions
class ModernSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final List<String>? suggestions;
  final bool showFilters;

  const ModernSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onFilterTap,
    this.suggestions,
    this.showFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        boxShadow: DesignTokens.softShadow(context),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: DesignTokens.bodyStyle.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hintText ?? 'Search...',
          hintStyle: DesignTokens.bodyStyle.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          suffixIcon: showFilters
              ? IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: onFilterTap,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingL,
            vertical: DesignTokens.spacingM,
          ),
        ),
      ),
    );
  }
}

