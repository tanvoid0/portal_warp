import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/design_tokens.dart';
import '../theme/app_theme.dart';

class GradientCard extends StatelessWidget {
  final Gradient gradient;
  final Widget child;
  final IconData? icon;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool enableAnimation;
  final String? backgroundImageUrl;

  const GradientCard({
    super.key,
    required this.gradient,
    required this.child,
    this.icon,
    this.onTap,
    this.padding,
    this.enableAnimation = false,
    this.backgroundImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).colorScheme.app;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget card = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        boxShadow: DesignTokens.softShadow(context),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        child: Stack(
          children: [
            // Background image (if provided)
            if (backgroundImageUrl != null)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: backgroundImageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                      gradient: gradient,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: gradient,
                    ),
                  ),
                ),
              ),
            // Gradient overlay (blends image with card, semi-transparent for text readability)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: backgroundImageUrl != null
                      ? [
                          gradient.colors.first.withOpacity(0.6),
                          gradient.colors.last.withOpacity(0.75),
                        ]
                      : gradient.colors,
                ),
              ),
            ),
            // Content with blur effect behind text for better readability
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                splashColor: appColors.textOnGradient.withOpacity(0.2),
                highlightColor: appColors.textOnGradient.withOpacity(0.1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        // Subtle dark overlay to enhance text contrast
                        color: isDark 
                            ? Colors.black.withOpacity(0.2)
                            : Colors.black.withOpacity(0.15),
                      ),
                      child: Padding(
                        padding: padding ?? const EdgeInsets.all(DesignTokens.spacingXL),
                        child: icon != null
                            ? Row(
                                children: [
                                  Icon(
                                    icon,
                                    color: appColors.textOnGradient,
                                    size: 32,
                                  ),
                                  const SizedBox(width: DesignTokens.spacingL),
                                  Expanded(child: child),
                                ],
                              )
                            : child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (enableAnimation) {
      return card
          .animate()
          .fadeIn(duration: 300.ms)
          .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 300.ms);
    }

    return card;
  }
}
