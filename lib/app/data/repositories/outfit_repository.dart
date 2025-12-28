import '../models/outfit.dart';
import '../local/json_storage.dart';

/// Repository for outfits using JSON file storage
class OutfitRepository {
  static const String _filename = 'outfits.json';

  Future<List<Outfit>> _loadOutfits() async {
    final data = await JsonStorage.readList(_filename);
    return data.map((json) {
      if (json['lastWorn'] != null && json['lastWorn'] is String) {
        json['lastWorn'] = DateTime.parse(json['lastWorn']).toIso8601String();
      }
      // Ensure type is a string for enum parsing
      if (json['type'] is! String) {
        json['type'] = (json['type'] as String? ?? 'casual');
      }
      return Outfit.fromJson(json);
    }).toList();
  }

  Future<void> _saveOutfits(List<Outfit> outfits) async {
    final data = outfits.map((o) {
      final json = o.toJson();
      if (o.lastWorn != null) {
        json['lastWorn'] = o.lastWorn!.toIso8601String();
      }
      return json;
    }).toList();
    await JsonStorage.writeList(_filename, data);
  }

  Future<List<Outfit>> getOutfits() async {
    return await _loadOutfits();
  }

  Future<List<Outfit>> getOutfitsByType(OutfitType type) async {
    final outfits = await _loadOutfits();
    return outfits.where((outfit) => outfit.type == type).toList();
  }

  Future<void> addOutfit(Outfit outfit) async {
    final outfits = await _loadOutfits();
    outfits.add(outfit);
    await _saveOutfits(outfits);
  }

  Future<void> updateOutfit(Outfit outfit) async {
    final outfits = await _loadOutfits();
    final index = outfits.indexWhere((o) => o.id == outfit.id);
    if (index != -1) {
      outfits[index] = outfit;
      await _saveOutfits(outfits);
    }
  }

  Future<void> markWorn(String id) async {
    final outfits = await _loadOutfits();
    final index = outfits.indexWhere((o) => o.id == id);
    if (index != -1) {
      final outfit = outfits[index];
      outfits[index] = outfit.copyWith(
        lastWorn: DateTime.now(),
        timesWorn: outfit.timesWorn + 1,
      );
      await _saveOutfits(outfits);
    }
  }

  Future<void> deleteOutfit(String id) async {
    final outfits = await _loadOutfits();
    outfits.removeWhere((outfit) => outfit.id == id);
    await _saveOutfits(outfits);
  }
}
