import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';
import '../theme/app_theme.dart';

/// Modern animated button with loading and success states
class AnimatedButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSuccess;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;

  const AnimatedButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isSuccess = false,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _wasSuccess = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(AnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSuccess && !oldWidget.isSuccess) {
      _wasSuccess = true;
      _controller.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            _controller.reverse();
            _wasSuccess = false;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.colorScheme.app;
    final bgColor = widget.backgroundColor ?? theme.colorScheme.primary;
    final fgColor = widget.foregroundColor ?? theme.colorScheme.onPrimary;

    Widget button = ElevatedButton(
      onPressed: widget.isLoading || widget.isSuccess ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _wasSuccess ? appColors.success : bgColor,
        foregroundColor: fgColor,
        padding: widget.padding ??
            const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingXL,
              vertical: DesignTokens.spacingL,
            ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        ),
        elevation: 0,
      ),
      child: _buildButtonContent(),
    );

    if (_wasSuccess) {
      button = button.animate(controller: _controller).scale(
            begin: const Offset(1, 1),
            end: const Offset(0.95, 0.95),
          );
    }

    return button;
  }

  Widget _buildButtonContent() {
    final theme = Theme.of(context);
    final appColors = theme.colorScheme.app;

    if (widget.isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingS),
          Text(widget.label),
        ],
      );
    }

    if (widget.isSuccess || _wasSuccess) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: theme.colorScheme.onPrimary,
            size: 20,
          ),
          const SizedBox(width: DesignTokens.spacingS),
          Text(widget.label),
        ],
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 20),
          const SizedBox(width: DesignTokens.spacingS),
          Text(widget.label),
        ],
      );
    }

    return Text(widget.label);
  }
}

