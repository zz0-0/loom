import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/settings_core/presentation/widgets/settings_content_providers.dart';
import 'package:loom/features/core/settings/settings_ui/presentation/widgets/settings_sidebar_item.dart';

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
