import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/design_tokens.dart';

/// Reusable confirmation dialog component
/// 
/// Provides a consistent confirmation dialog pattern across the app.
/// Supports both regular and destructive (error-styled) confirm actions.
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    this.onConfirm,
    this.onCancel,
  });

  /// Shows the confirmation dialog and returns true if confirmed
  static Future<bool> show({
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await Get.dialog<bool>(
      ConfirmationDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            onCancel?.call();
            Get.back(result: false);
          },
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () {
            onConfirm?.call();
            Get.back(result: true);
          },
          style: isDestructive
              ? TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                )
              : null,
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

