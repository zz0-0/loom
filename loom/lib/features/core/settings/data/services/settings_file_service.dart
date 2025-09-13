import 'dart:convert';
import 'dart:io';

/// Service for handling settings file I/O operations
class SettingsFileService {
  const SettingsFileService();

  /// Read JSON data from a settings file
  Map<String, dynamic>? readJsonFile(String fileName) {
    try {
      final file = File(fileName);

      if (!file.existsSync()) {
        return null;
      }

      final jsonString = file.readAsStringSync();
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Write JSON data to a settings file
  void writeJsonFile(String fileName, Map<String, dynamic> data) {
    final file = File(fileName);
    final jsonString = json.encode(data);
    file.writeAsStringSync(jsonString);
  }

  /// Check if a settings file exists
  bool fileExists(String fileName) {
    final file = File(fileName);

    return file.existsSync();
  }

  /// Delete a settings file
  void deleteFile(String fileName) {
    final file = File(fileName);

    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}
