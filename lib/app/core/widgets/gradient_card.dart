import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';

class GradientCard extends StatelessWidget {
  final Gradient gradient;
  final Widget child;
  final IconData? icon;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool enableAnimation;

  const GradientCard({
    super.key,
    required this.gradient,
    required this.child,
    this.icon,
    this.onTap,
    this.padding,
    this.enableAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        boxShadow: DesignTokens.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(DesignTokens.spacingXL),
            child: icon != null
                ? Row(
                    children: [
                      Icon(
                        icon,
                        color: Colors.white,
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
