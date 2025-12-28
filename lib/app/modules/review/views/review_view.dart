import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/review_controller.dart';
import '../../../core/widgets/gradient_card.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../data/models/focus_area.dart';

class ReviewView extends GetView<ReviewController> {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Review'),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNavBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final review = controller.weeklyReview.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This Week\'s Summary',
                style: DesignTokens.headlineStyle,
              ),
              const SizedBox(height: DesignTokens.spacingXL),

              // Completion Stats
              if (review.completionStats.isNotEmpty) ...[
                Text(
                  'Completion by Area',
                  style: DesignTokens.titleStyle,
                ),
                const SizedBox(height: DesignTokens.spacingL),
                ...review.completionStats.entries.map((entry) {
                  final area = entry.key;
                  final rate = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: DesignTokens.spacingM),
                    child: _buildStatCard(area.displayName, rate),
                  );
                }),
                const SizedBox(height: DesignTokens.spacingXL),
              ],

              // Avoided Areas
              if (review.avoidedAreas.isNotEmpty) ...[
                GradientCard(
                  gradient: DesignTokens.questGradient,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Areas to Focus On',
                        style: DesignTokens.titleStyle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingM),
                      ...review.avoidedAreas.map((area) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
                          child: Text(
                            '• ${area.displayName}',
                            style: DesignTokens.bodyStyle.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXL),
              ],

              // Recommendation
              if (review.oneAdjustment != null) ...[
                Text(
                  'This Week\'s Recommendation',
                  style: DesignTokens.titleStyle,
                ),
                const SizedBox(height: DesignTokens.spacingL),
                GradientCard(
                  gradient: DesignTokens.planningGradient,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(width: DesignTokens.spacingM),
                          Expanded(
                            child: Text(
                              review.oneAdjustment!,
                              style: DesignTokens.bodyStyle.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0, duration: 400.ms),
              ],

              const SizedBox(height: DesignTokens.spacingXXL),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String area, double rate) {
    final percentage = (rate * 100).toStringAsFixed(0);
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingL),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            area,
            style: DesignTokens.bodyStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  value: rate,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    rate >= 0.7
                        ? Colors.green
                        : rate >= 0.4
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Text(
                '$percentage%',
                style: DesignTokens.titleStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
