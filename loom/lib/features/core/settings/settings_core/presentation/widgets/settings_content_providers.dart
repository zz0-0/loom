import 'package:flutter/material.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/settings_appearance/presentation/widgets/appearance_settings_page.dart';
import 'package:loom/features/core/settings/settings_core/presentation/widgets/about_settings_page.dart';
import 'package:loom/features/core/settings/settings_general/presentation/widgets/general_settings_page.dart';
import 'package:loom/features/core/settings/settings_interface/presentation/widgets/interface_settings_page.dart';

/// Settings content provider that displays settings in the main content area
class SettingsContentProvider implements ContentProvider {
  @override
  String get id => 'settings';

  @override
  bool canHandle(String? contentId) {
    return contentId == 'settings';
  }

  @override
  Widget build(BuildContext context) {
    // Default to appearance settings when just 'settings' is requested
    return const AppearanceSettingsPage();
  }
}

/// Appearance settings content provider
class AppearanceSettingsContentProvider implements ContentProvider {
  @override
  String get id => 'settings:appearance';

  @override
  bool canHandle(String? contentId) {
    return contentId == 'settings:appearance';
  }

  @override
  Widget build(BuildContext context) {
    return const AppearanceSettingsPage();
  }
}

/// Interface settings content provider
class InterfaceSettingsContentProvider implements ContentProvider {
  @override
  String get id => 'settings:interface';

  @override
  bool canHandle(String? contentId) {
    return contentId == 'settings:interface';
  }

  @override
  Widget build(BuildContext context) {
    return const InterfaceSettingsPage();
  }
}

/// General settings content provider
class GeneralSettingsContentProvider implements ContentProvider {
  @override
  String get id => 'settings:general';

  @override
  bool canHandle(String? contentId) {
    return contentId == 'settings:general';
  }

  @override
  Widget build(BuildContext context) {
    return const GeneralSettingsPage();
  }
}

/// About settings content provider
class AboutSettingsContentProvider implements ContentProvider {
  @override
  String get id => 'settings:about';

  @override
  bool canHandle(String? contentId) {
    return contentId == 'settings:about';
  }

  @override
  Widget build(BuildContext context) {
    return const AboutSettingsPage();
  }
}
