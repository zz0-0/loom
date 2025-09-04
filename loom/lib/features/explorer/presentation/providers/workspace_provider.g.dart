// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentWorkspaceHash() => r'38b7c87e7e702a9f8ba2b9de1f65e9281f12181d';

/// Current workspace state
///
/// Copied from [CurrentWorkspace].
@ProviderFor(CurrentWorkspace)
final currentWorkspaceProvider =
    NotifierProvider<CurrentWorkspace, models.Workspace?>.internal(
  CurrentWorkspace.new,
  name: r'currentWorkspaceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentWorkspaceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentWorkspace = Notifier<models.Workspace?>;
String _$explorerViewModeHash() => r'ad55f46bb424205f29aaea948c09e54a6989f4ea';

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
    r'835575c94e9659462f0e9fa4cc48930842a6fa99';

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
