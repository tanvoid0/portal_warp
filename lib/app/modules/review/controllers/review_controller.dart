import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/weekly_review.dart';
import '../../../data/repositories/quests_repository.dart';
import '../../../data/repositories/templates_repository.dart';
import '../../../core/services/review_service.dart';

class ReviewController extends GetxController {
  final QuestsRepository _questsRepo = QuestsRepository();
  final TemplatesRepository _templatesRepo = TemplatesRepository();
  late final ReviewService _reviewService;

  @override
  void onInit() {
    super.onInit();
    _reviewService = ReviewService(_questsRepo, _templatesRepo);
    _loadWeeklyReview();
  }

  final weeklyReview = WeeklyReview(
    weekStart: DateTime.now(),
  ).obs;
  final isLoading = true.obs;

  Future<void> _loadWeeklyReview() async {
    isLoading.value = true;
    try {
      // Get the start of the current week (Monday)
      final now = DateTime.now();
      final daysFromMonday = now.weekday - 1;
      final weekStart = now.subtract(Duration(days: daysFromMonday));
      final weekStartOnly = DateTime(weekStart.year, weekStart.month, weekStart.day);

      weeklyReview.value = await _reviewService.generateWeeklyReview(weekStartOnly);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load weekly review: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
