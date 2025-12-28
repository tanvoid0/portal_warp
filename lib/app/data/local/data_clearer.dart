import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service to clear all JSON data files
/// This allows users to start fresh and re-import cheatsheet data
class DataClearer {
  static Future<Directory> get _dataDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    final dataDir = Directory(path.join(directory.path, 'portal_warp_data'));
    return dataDir;
  }

  /// Clear all data files (except cheatsheet_data.json which is an asset)
  static Future<void> clearAllData() async {
    final dataDir = await _dataDirectory;
    
    if (!await dataDir.exists()) {
      return; // Nothing to clear
    }

    // List of data files to clear
    final filesToClear = [
      'drawer_items.json',
      'shopping_items.json',
      'plan_items.json',
      'templates.json',
      'quest_instances.json',
      'outfits.json',
      // Note: user_prefs.json is kept to preserve user settings
      // Note: cheatsheet_data.json local copy will be overwritten on next import
    ];

    for (final filename in filesToClear) {
      final file = File(path.join(dataDir.path, filename));
      if (await file.exists()) {
        await file.delete();
      }
    }

    // Also clear the local cheatsheet_data.json copy
    final cheatsheetFile = File(path.join(dataDir.path, 'cheatsheet_data.json'));
    if (await cheatsheetFile.exists()) {
      await cheatsheetFile.delete();
    }
  }

  /// Clear specific data file
  static Future<void> clearDataFile(String filename) async {
    final dataDir = await _dataDirectory;
    final file = File(path.join(dataDir.path, filename));
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Clear drawer items
  static Future<void> clearDrawerItems() async {
    await clearDataFile('drawer_items.json');
  }

  /// Clear shopping items
  static Future<void> clearShoppingItems() async {
    await clearDataFile('shopping_items.json');
  }

  /// Clear plan items
  static Future<void> clearPlanItems() async {
    await clearDataFile('plan_items.json');
  }

  /// Clear quest instances
  static Future<void> clearQuestInstances() async {
    await clearDataFile('quest_instances.json');
  }

  /// Clear templates (will be re-seeded)
  static Future<void> clearTemplates() async {
    await clearDataFile('templates.json');
  }
}

