import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/menu_system.dart';

/// Provider for top bar settings
class TopBarSettingsNotifier extends StateNotifier<TopBarSettings> {
  TopBarSettingsNotifier() : super(const TopBarSettings());

  void setShowTitle({required bool show}) {
    state = state.copyWith(showTitle: show);
  }

  void setShowSearch({required bool show}) {
    state = state.copyWith(showSearch: show);
  }

  void setShowMenuAsHamburger({required bool show}) {
    state = state.copyWith(showMenuAsHamburger: show);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }
}

final topBarSettingsProvider =
    StateNotifierProvider<TopBarSettingsNotifier, TopBarSettings>(
  (ref) => TopBarSettingsNotifier(),
);
