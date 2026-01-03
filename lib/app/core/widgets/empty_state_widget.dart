import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';

/// Beautiful empty state widget with icon, message, and optional CTA
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? customIllustration;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.customIllustration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration or Icon
            if (customIllustration != null)
              customIllustration!
            else
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.1),
                      theme.colorScheme.secondary.withOpacity(0.05),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: theme.colorScheme.primary.withOpacity(0.6),
                ),
              )
                  .animate()
                  .scale(
                    delay: 200.ms,
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),
            const SizedBox(height: DesignTokens.spacingXL),
            // Title
            Text(
              title,
              style: DesignTokens.titleStyle.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 400.ms)
                .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 400.ms),
            if (message != null) ...[
              const SizedBox(height: DesignTokens.spacingM),
              Text(
                message!,
                style: DesignTokens.bodyStyle.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0, delay: 500.ms, duration: 400.ms),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: DesignTokens.spacingXL),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingXL,
                    vertical: DesignTokens.spacingL,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 400.ms)
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                    delay: 600.ms,
                    duration: 400.ms,
                    curve: Curves.elasticOut,
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

