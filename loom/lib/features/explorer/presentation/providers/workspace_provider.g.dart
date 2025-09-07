// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentWorkspaceHash() => r'756b9358927af945e5a70d2451f23981cea38a5f';

/// Current workspace state
///
/// Copied from [CurrentWorkspace].
@ProviderFor(CurrentWorkspace)
final currentWorkspaceProvider =
    NotifierProvider<CurrentWorkspace, domain.Workspace?>.internal(
  CurrentWorkspace.new,
  name: r'currentWorkspaceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentWorkspaceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentWorkspace = Notifier<domain.Workspace?>;
String _$explorerViewModeHash() => r'a0fbe0c9adfd48648fac6b6ea8d904708fae40f8';

/// Explorer view mode (filesystem or collections)
///
/// Copied from [ExplorerViewMode].
@ProviderFor(ExplorerViewMode)
final explorerViewModeProvider =
    AutoDisposeNotifierProvider<ExplorerViewMode, String>.internal(
  ExplorerViewMode.new,
  name: r'explorerViewModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$explorerViewModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExplorerViewMode = AutoDisposeNotifier<String>;
String _$selectedSidebarViewHash() =>
    r'd41ba22ad6bb7b38635eaad08ca8c7ea5164585b';

/// Currently selected sidebar view
///
/// Copied from [SelectedSidebarView].
@ProviderFor(SelectedSidebarView)
final selectedSidebarViewProvider =
    AutoDisposeNotifierProvider<SelectedSidebarView, String?>.internal(
  SelectedSidebarView.new,
  name: r'selectedSidebarViewProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedSidebarViewHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedSidebarView = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
