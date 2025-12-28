import 'package:freezed_annotation/freezed_annotation.dart';
import 'focus_area.dart';

part 'quest_template.freezed.dart';
part 'quest_template.g.dart';

@freezed
class QuestTemplate with _$QuestTemplate {
  const factory QuestTemplate({
    required String id,
    required FocusArea focusAreaId,
    required String title,
    @Default(10) int durationBucket, // 2, 10, or 30 minutes
    @Default(3) int difficulty, // 1-5
    @Default(0) int cooldownDays,
    @Default('') String instructions,
    @Default([]) List<String> tags,
  }) = _QuestTemplate;

  factory QuestTemplate.fromJson(Map<String, dynamic> json) =>
      _$QuestTemplateFromJson(json);
}

