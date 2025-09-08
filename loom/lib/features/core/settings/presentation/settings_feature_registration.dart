import 'package:loom/features/core/settings/presentation/widgets/settings_content.dart';
import 'package:loom/features/core/settings/presentation/widgets/settings_sidebar_item.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';

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
