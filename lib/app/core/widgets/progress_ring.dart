import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

/// Circular progress ring with animations
class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final Widget? child;
  final bool animate;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 70,
    this.strokeWidth = 6,
    this.backgroundColor,
    this.progressColor,
    this.child,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.colorScheme.app;
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = backgroundColor ??
        (isDark
            ? appColors.textOnGradient.withOpacity(0.1)
            : appColors.textOnGradient.withOpacity(0.15));
    final progColor = progressColor ?? theme.colorScheme.primary;

    Widget ring = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        strokeWidth: strokeWidth,
        backgroundColor: bgColor,
        valueColor: AlwaysStoppedAnimation<Color>(progColor),
        strokeCap: StrokeCap.round,
      ),
    );

    if (animate) {
      ring = ring.animate(
        onPlay: (controller) => controller.repeat(),
      ).shimmer(
        duration: 2000.ms,
        color: progColor.withOpacity(0.3),
      );
    }

    if (child != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ring,
          child!,
        ],
      );
    }

    return ring;
  }
}

