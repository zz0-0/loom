import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';

/// Settings feature registration
/// This should be called during app initialization to register settings components
class SettingsFeatureRegistration {
  static void register() {
    UIRegistry()
      ..registerSidebarItem(SettingsSidebarItem())
      ..registerContentProvider(SettingsContentProvider())
      ..registerContentProvider(AppearanceSettingsContentProvider())
      ..registerContentProvider(InterfaceSettingsContentProvider())
      ..registerContentProvider(GeneralSettingsContentProvider())
      ..registerContentProvider(AboutSettingsContentProvider());
  }
}
