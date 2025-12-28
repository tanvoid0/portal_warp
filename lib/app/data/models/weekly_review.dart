import 'package:freezed_annotation/freezed_annotation.dart';
import 'focus_area.dart';

part 'weekly_review.freezed.dart';
part 'weekly_review.g.dart';

@freezed
class WeeklyReview with _$WeeklyReview {
  const factory WeeklyReview({
    required DateTime weekStart,
    @Default({}) Map<FocusArea, double> completionStats, // 0.0 to 1.0
    @Default([]) List<FocusArea> avoidedAreas,
    String? oneAdjustment,
  }) = _WeeklyReview;

  factory WeeklyReview.fromJson(Map<String, dynamic> json) =>
      _$WeeklyReviewFromJson(json);
}

