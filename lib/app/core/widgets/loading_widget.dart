import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// Reusable loading state widget
/// 
/// Provides consistent loading indicators across the app.
/// Supports both full-screen and inline loading states.
class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool isFullScreen;
  final double? size;
  final double strokeWidth;

  const LoadingWidget({
    super.key,
    this.message,
    this.isFullScreen = true,
    this.size,
    this.strokeWidth = 4.0,
  });

  /// Creates a full-screen loading widget
  const LoadingWidget.fullScreen({
    super.key,
    this.message,
    this.size,
    this.strokeWidth = 4.0,
  }) : isFullScreen = true;

  /// Creates an inline loading widget
  const LoadingWidget.inline({
    super.key,
    this.message,
    this.size,
    this.strokeWidth = 2.0,
  }) : isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
      ),
    );

    if (message != null) {
      final content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: DesignTokens.spacingL),
          Text(
            message!,
            style: DesignTokens.bodyStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );

      if (isFullScreen) {
        return Center(child: content);
      }
      return content;
    }

    if (isFullScreen) {
      return Center(child: indicator);
    }
    return indicator;
  }
}

