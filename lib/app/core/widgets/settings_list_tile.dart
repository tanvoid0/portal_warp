import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// Reusable settings list tile component
/// 
/// Provides common patterns for settings UI:
/// - Switch toggle
/// - Navigation with chevron
/// - Custom trailing widget
class SettingsListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Widget? trailing;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;
  final bool showChevron;

  const SettingsListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailing,
    this.switchValue,
    this.onSwitchChanged,
    this.onTap,
    this.showChevron = false,
  });

  /// Creates a switch list tile
  const SettingsListTile.switch_({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    required this.switchValue,
    required this.onSwitchChanged,
  })  : trailing = null,
        onTap = null,
        showChevron = false;

  /// Creates a navigation list tile
  const SettingsListTile.navigation({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    required this.onTap,
  })  : trailing = null,
        switchValue = null,
        onSwitchChanged = null,
        showChevron = true;

  /// Creates a list tile with custom trailing widget
  const SettingsListTile.custom({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    required this.trailing,
    this.onTap,
  })  : switchValue = null,
        onSwitchChanged = null,
        showChevron = false;

  @override
  Widget build(BuildContext context) {
    Widget? trailingWidget = trailing;

    if (switchValue != null) {
      trailingWidget = Switch(
        value: switchValue!,
        onChanged: onSwitchChanged,
      );
    } else if (showChevron) {
      trailingWidget = Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );
    }

    return ListTile(
      leading: leadingIcon != null
          ? Icon(
              leadingIcon,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailingWidget,
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}

