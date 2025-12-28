import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// JSON storage service for local file-based persistence
/// This will be replaced with a backend/database in the future
class JsonStorage {
  static Future<Directory> get _dataDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    final dataDir = Directory(path.join(directory.path, 'portal_warp_data'));
    if (!await dataDir.exists()) {
      await dataDir.create(recursive: true);
    }
    return dataDir;
  }

  static Future<File> _getFile(String filename) async {
    final dir = await _dataDirectory;
    return File(path.join(dir.path, filename));
  }

  /// Read JSON data from file
  static Future<List<Map<String, dynamic>>> readList(String filename) async {
    try {
      final file = await _getFile(filename);
      if (!await file.exists()) {
        return [];
      }
      final content = await file.readAsString();
      if (content.isEmpty) {
        return [];
      }
      final decoded = jsonDecode(content) as List;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Write JSON data to file
  static Future<void> writeList(String filename, List<Map<String, dynamic>> data) async {
    final file = await _getFile(filename);
    final content = jsonEncode(data);
    await file.writeAsString(content);
  }

  /// Read a single JSON object from file
  static Future<Map<String, dynamic>?> readObject(String filename) async {
    try {
      final file = await _getFile(filename);
      if (!await file.exists()) {
        return null;
      }
      final content = await file.readAsString();
      if (content.isEmpty) {
        return null;
      }
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Write a single JSON object to file
  static Future<void> writeObject(String filename, Map<String, dynamic> data) async {
    final file = await _getFile(filename);
    final content = jsonEncode(data);
    await file.writeAsString(content);
  }
}

