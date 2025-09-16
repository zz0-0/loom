/// Shared settings repository interface
/// This allows shared components to access settings without depending on specific features
abstract class SharedSettingsRepository {
  Future<String> getTheme();
  Future<void> setTheme(String theme);
  Future<Map<String, dynamic>> getFontSettings();
  Future<void> setFontSettings(Map<String, dynamic> fontSettings);
}
