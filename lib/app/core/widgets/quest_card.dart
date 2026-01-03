import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/design_tokens.dart';
import '../services/unsplash_service.dart';
import 'gradient_card.dart';

class QuestCard extends StatefulWidget {
  final String title;
  final String focusArea;
  final int durationMinutes;
  final Gradient gradient;
  final VoidCallback? onDone;
  final VoidCallback? onSkip;
  final bool isCompleted;
  final int? xpAwarded;

  const QuestCard({
    super.key,
    required this.title,
    required this.focusArea,
    required this.durationMinutes,
    required this.gradient,
    this.onDone,
    this.onSkip,
    this.isCompleted = false,
    this.xpAwarded,
  });

  @override
  State<QuestCard> createState() => _QuestCardState();
}

class _QuestCardState extends State<QuestCard> {
  bool _showXpOverlay = false;

  @override
  void didUpdateWidget(QuestCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Show XP overlay when quest becomes completed
    if (widget.isCompleted && !oldWidget.isCompleted && widget.xpAwarded != null) {
      _showXpOverlay = true;
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            _showXpOverlay = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImageUrl = UnsplashService.getQuestCardImageUrl(widget.focusArea);
    
    return Stack(
      children: [
        GradientCard(
          gradient: widget.gradient,
          backgroundImageUrl: backgroundImageUrl,
          onTap: widget.isCompleted ? null : widget.onDone,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingM,
                      vertical: DesignTokens.spacingS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    ),
                    child: Text(
                      widget.focusArea.toUpperCase(),
                      style: DesignTokens.captionStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (widget.isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingL),
              Text(
                widget.title,
                style: DesignTokens.titleStyle.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingM),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: DesignTokens.spacingS),
                  Text(
                    '${widget.durationMinutes} min',
                    style: DesignTokens.bodyStyle.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              if (!widget.isCompleted && (widget.onDone != null || widget.onSkip != null)) ...[
                const SizedBox(height: DesignTokens.spacingXL),
                Row(
                  children: [
                    if (widget.onSkip != null) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onSkip,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                            padding: const EdgeInsets.symmetric(
                              vertical: DesignTokens.spacingL,
                            ),
                          ),
                          child: const Text('Skip'),
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingM),
                    ],
                    if (widget.onDone != null)
                      Expanded(
                        flex: widget.onSkip != null ? 2 : 1,
                        child: ElevatedButton(
                          onPressed: widget.onDone,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(
                              vertical: DesignTokens.spacingL,
                            ),
                          ),
                          child: const Text('Done'),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.1, end: 0, duration: 400.ms)
            .then()
            .scale(
              begin: widget.isCompleted ? const Offset(1.0, 1.0) : const Offset(1.0, 1.0),
              end: widget.isCompleted ? const Offset(1.05, 1.05) : const Offset(1.0, 1.0),
              duration: 300.ms,
              curve: Curves.easeOut,
            ),
        // XP Overlay
        if (_showXpOverlay && widget.xpAwarded != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: widget.gradient,
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 48,
                    ),
                    const SizedBox(height: DesignTokens.spacingM),
                    Text(
                      '+${widget.xpAwarded} XP',
                      style: DesignTokens.headlineStyle.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(begin: const Offset(0.8, 0.8), duration: 400.ms, curve: Curves.easeOut)
                .then()
                .fadeOut(duration: 300.ms),
          ),
      ],
    );
  }
}

