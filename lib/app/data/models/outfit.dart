import 'package:freezed_annotation/freezed_annotation.dart';

part 'outfit.freezed.dart';
part 'outfit.g.dart';

enum OutfitType {
  casual,
  professional;

  String get displayName {
    switch (this) {
      case OutfitType.casual:
        return 'Casual';
      case OutfitType.professional:
        return 'Professional';
    }
  }
}

@freezed
class Outfit with _$Outfit {
  const factory Outfit({
    required String id,
    required String name,
    required OutfitType type,
    @Default('') String top,
    @Default('') String bottom,
    @Default('') String shoes,
    @Default('') String layer, // jacket/blazer
    @Default('') String accessories,
    @Default('') String notes,
    DateTime? lastWorn,
    @Default(0) int timesWorn,
  }) = _Outfit;

  factory Outfit.fromJson(Map<String, dynamic> json) => _$OutfitFromJson(json);
}

