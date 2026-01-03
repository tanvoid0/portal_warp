import 'package:get/get.dart';
import '../models/outfit.dart';
import '../local/json_storage.dart';
import '../../core/services/api_client.dart';

/// Repository for outfits with hybrid sync (API + local cache)
class OutfitRepository {
  static const String _cacheFilename = 'outfits_cache.json';
  
  ApiClient? get _apiClient {
    try {
      return Get.find<ApiClient>();
    } catch (_) {
      return null;
    }
  }

  // ============ Cache Methods ============
  
  Future<List<Outfit>> _loadFromCache() async {
    final data = await JsonStorage.readList(_cacheFilename);
    return data.map((json) {
      if (json['lastWorn'] != null && json['lastWorn'] is String) {
        json['lastWorn'] = DateTime.parse(json['lastWorn']).toIso8601String();
      }
      if (json['type'] is! String) {
        json['type'] = (json['type'] as String? ?? 'casual');
      }
      return Outfit.fromJson(json);
    }).toList();
  }

  Future<void> _saveToCache(List<Outfit> outfits) async {
    final data = outfits.map((o) {
      final json = o.toJson();
      if (o.lastWorn != null) {
        json['lastWorn'] = o.lastWorn!.toIso8601String();
      }
      return json;
    }).toList();
    await JsonStorage.writeList(_cacheFilename, data);
  }

  // ============ API Methods ============

  Future<List<Outfit>> getOutfits() async {
    final api = _apiClient;
    if (api == null) return _loadFromCache();
    
    try {
      final response = await api.get('/outfits');
      final items = (response as List)
          .map((json) => _mapApiToOutfit(json))
          .toList();
      await _saveToCache(items);
      return items;
    } on ApiException {
      rethrow;
    } catch (e) {
      return _loadFromCache();
    }
  }

  Future<List<Outfit>> getOutfitsByType(OutfitType type) async {
    final api = _apiClient;
    if (api == null) {
      final outfits = await _loadFromCache();
      return outfits.where((outfit) => outfit.type == type).toList();
    }
    
    try {
      final response = await api.get('/outfits', queryParams: {'type': type.name});
      return (response as List)
          .map((json) => _mapApiToOutfit(json))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      final outfits = await _loadFromCache();
      return outfits.where((outfit) => outfit.type == type).toList();
    }
  }

  Future<void> addOutfit(Outfit outfit) async {
    final api = _apiClient;
    if (api == null) {
      final outfits = await _loadFromCache();
      outfits.add(outfit);
      await _saveToCache(outfits);
      return;
    }
    
    await api.post('/outfits', body: _mapOutfitToApi(outfit));
  }

  Future<void> updateOutfit(Outfit outfit) async {
    final api = _apiClient;
    if (api == null) {
      final outfits = await _loadFromCache();
      final index = outfits.indexWhere((o) => o.id == outfit.id);
      if (index != -1) {
        outfits[index] = outfit;
        await _saveToCache(outfits);
      }
      return;
    }
    
    await api.put('/outfits/${outfit.id}', body: _mapOutfitToApi(outfit));
  }

  Future<void> markWorn(String id) async {
    final api = _apiClient;
    if (api == null) {
      final outfits = await _loadFromCache();
      final index = outfits.indexWhere((o) => o.id == id);
      if (index != -1) {
        final outfit = outfits[index];
        outfits[index] = outfit.copyWith(
          lastWorn: DateTime.now(),
          timesWorn: outfit.timesWorn + 1,
        );
        await _saveToCache(outfits);
      }
      return;
    }
    
    await api.patch('/outfits/$id/worn');
  }

  Future<void> deleteOutfit(String id) async {
    final api = _apiClient;
    if (api == null) {
      final outfits = await _loadFromCache();
      outfits.removeWhere((outfit) => outfit.id == id);
      await _saveToCache(outfits);
      return;
    }
    
    await api.delete('/outfits/$id');
  }
  
  // ============ Mapping Helpers ============
  
  Outfit _mapApiToOutfit(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] == 'professional' 
          ? OutfitType.professional 
          : OutfitType.casual,
      top: json['top'] ?? '',
      bottom: json['bottom'] ?? '',
      shoes: json['shoes'] ?? '',
      layer: json['layer'] ?? '',
      accessories: json['accessories'] ?? '',
      notes: json['notes'] ?? '',
      lastWorn: json['last_worn'] != null 
          ? DateTime.parse(json['last_worn']) 
          : null,
      timesWorn: json['times_worn'] ?? 0,
    );
  }
  
  Map<String, dynamic> _mapOutfitToApi(Outfit outfit) {
    return {
      'name': outfit.name,
      'type': outfit.type.name,
      'top': outfit.top,
      'bottom': outfit.bottom,
      'shoes': outfit.shoes,
      'layer': outfit.layer,
      'accessories': outfit.accessories,
      'notes': outfit.notes,
    };
  }
}
