import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest_instance.freezed.dart';
part 'quest_instance.g.dart';

enum QuestStatus {
  todo,
  done,
  skip;

  String get displayName {
    switch (this) {
      case QuestStatus.todo:
        return 'To Do';
      case QuestStatus.done:
        return 'Done';
      case QuestStatus.skip:
        return 'Skipped';
    }
  }
}

@freezed
class QuestInstance with _$QuestInstance {
  const factory QuestInstance({
    required String id,
    required DateTime date,
    required String templateId,
    @Default(QuestStatus.todo) QuestStatus status,
    @Default(0) int xpAwarded,
    String? note,
  }) = _QuestInstance;

  factory QuestInstance.fromJson(Map<String, dynamic> json) =>
      _$QuestInstanceFromJson(json);
}

