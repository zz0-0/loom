import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';
import 'package:loom/plugins/core/plugin_manager.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Mobile-specific layout with completely different UX patterns
/// - AppBar with hamburger menu instead of fixed top bar
/// - Bottom navigation instead of sidebar
/// - Drawer navigation instead of side panels
/// - Full-screen content editing
/// - Modal sheets for secondary content
class MobileLayout extends ConsumerStatefulWidget {
  const MobileLayout({super.key});

  @override
  ConsumerState<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<MobileLayout> {
  int _selectedBottomNavIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initializePluginSystem();
  }

  /// Initialize the plugin system
  Future<void> _initializePluginSystem() async {
    try {
      // Plugin system v2.0 is already initialized in main.dart
      // We can handle any UI-specific plugin initialization here if needed
      await PluginManager.instance
          .handleUIEvent('layout_initialized', {'layout': 'mobile'});
    } catch (e) {
      debugPrint('Failed to initialize plugin system: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(uiStateProvider);
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,

      // Mobile AppBar (completely different from desktop top bar)
      appBar: AppBar(
        title: const Text('Loom'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () => _showSearchModal(context),
          ),
          IconButton(
            icon: const Icon(LucideIcons.moreVertical),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),

      // Drawer instead of side panel (mobile pattern)
      drawer: _buildMobileDrawer(context),

      // Main content based on bottom navigation selection
      body: _buildMobileContent(context, _selectedBottomNavIndex, uiState),

      // Bottom navigation instead of sidebar icons (mobile pattern)
      bottomNavigationBar: _buildBottomNavigation(context),

      // Floating action button for quick actions (mobile pattern)
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          // Drawer header
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.book,
                  size: 40,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 8),
                Text(
                  'Loom Knowledge Base',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your workspace',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Drawer items (different from desktop sidebar)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: LucideIcons.folderOpen,
                  title: 'Recent Files',
                  onTap: _navigateToRecentFiles,
                ),
                _DrawerItem(
                  icon: LucideIcons.star,
                  title: 'Favorites',
                  onTap: _navigateToFavorites,
                ),
                _DrawerItem(
                  icon: LucideIcons.clock,
                  title: 'History',
                  onTap: _navigateToHistory,
                ),
                const Divider(),
                _DrawerItem(
                  icon: LucideIcons.puzzle,
                  title: 'Plugins',
                  onTap: _navigateToPlugins,
                ),
                _DrawerItem(
                  icon: LucideIcons.settings,
                  title: 'Settings',
                  onTap: _navigateToSettings,
                ),
                _DrawerItem(
                  icon: LucideIcons.helpCircle,
                  title: 'Help & Support',
                  onTap: _navigateToHelp,
                ),
              ],
            ),
          ),

          // Drawer footer
          Container(
            padding: AppSpacing.paddingMd,
            child: Column(
              children: [
                _DrawerItem(
                  icon: LucideIcons.moon,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (value) {
                      // Toggle between dark and light themes
                      if (value) {
                        ref
                            .read(customThemeProvider.notifier)
                            .setTheme(BuiltInThemes.defaultDark);
                      } else {
                        ref
                            .read(customThemeProvider.notifier)
                            .setTheme(BuiltInThemes.defaultLight);
                      }
                    },
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileContent(
    BuildContext context,
    int selectedIndex,
    UIState uiState,
  ) {
    switch (selectedIndex) {
      case 0: // Documents
        return const _MobileDocumentsView();
      case 1: // Search
        return const _MobileSearchView();
      case 2: // Editor
        return ContentArea(openedFile: uiState.openedFile);
      case 3: // Collections
        return const _MobileCollectionsView();
      default:
        return const _MobileDocumentsView();
    }
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedBottomNavIndex,
      onTap: (index) {
        setState(() {
          _selectedBottomNavIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.fileText),
          label: 'Documents',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.edit),
          label: 'Editor',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.bookmark),
          label: 'Collections',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateOptions(context),
      child: const Icon(LucideIcons.plus),
    );
  }

  // Mobile-specific actions
  void _showSearchModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _MobileSearchModal(),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => const _MobileOptionsMenu(),
    );
  }

  void _showCreateOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => const _MobileCreateOptions(),
    );
  }

  void _showPluginsModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _MobilePluginsModal(),
    );
  }

  // Navigation methods
  void _navigateToRecentFiles() {
    Navigator.pop(context);
    setState(() => _selectedBottomNavIndex = 0);
  }

  void _navigateToFavorites() {
    Navigator.pop(context);
    // Navigate to favorites
  }

  void _navigateToHistory() {
    Navigator.pop(context);
    // Navigate to history
  }

  void _navigateToPlugins() {
    Navigator.pop(context);
    _showPluginsModal(context);
  }

  void _navigateToSettings() {
    Navigator.pop(context);
    // Navigate to settings
  }

  void _navigateToHelp() {
    Navigator.pop(context);
    // Navigate to help
  }
}

// Mobile-specific widgets

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
      dense: true,
    );
  }
}

// Mobile-specific content views

class _MobileDocumentsView extends StatelessWidget {
  const _MobileDocumentsView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.paddingMd,
      children: [
        Card(
          child: ListTile(
            leading: const Icon(LucideIcons.fileText),
            title: const Text('Getting Started'),
            subtitle: const Text('Welcome to your knowledge base'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () {
              // Open file
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(LucideIcons.fileCode),
            title: const Text('Project Notes'),
            subtitle: const Text('Development documentation'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () {
              // Open file
            },
          ),
        ),
        // More documents...
      ],
    );
  }
}

class _MobileSearchView extends StatelessWidget {
  const _MobileSearchView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: AppSpacing.paddingMd,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search your knowledge base...',
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              prefixIcon: const Icon(LucideIcons.search),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: Center(
              child: Text('Search results will appear here'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileCollectionsView extends StatelessWidget {
  const _MobileCollectionsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Collections view for mobile'),
    );
  }
}

// Mobile modal sheets

class _MobileSearchModal extends StatelessWidget {
  const _MobileSearchModal();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: AppSpacing.paddingMd,
      child: Column(
        children: [
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search everything...',
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              prefixIcon: const Icon(LucideIcons.search),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Mobile search interface'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileOptionsMenu extends StatelessWidget {
  const _MobileOptionsMenu();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(LucideIcons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(LucideIcons.share),
            title: Text('Share'),
          ),
          ListTile(
            leading: Icon(LucideIcons.download),
            title: Text('Export'),
          ),
        ],
      ),
    );
  }
}

class _MobileCreateOptions extends StatelessWidget {
  const _MobileCreateOptions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(LucideIcons.fileText),
            title: Text('New Document'),
          ),
          ListTile(
            leading: Icon(LucideIcons.folder),
            title: Text('New Folder'),
          ),
          ListTile(
            leading: Icon(LucideIcons.camera),
            title: Text('Scan Document'),
          ),
        ],
      ),
    );
  }
}

class _MobilePluginsModal extends StatelessWidget {
  const _MobilePluginsModal();

  @override
  Widget build(BuildContext context) {
    final pluginManager = PluginManager.instance;
    final activePlugins = pluginManager.getActivePlugins();
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: AppSpacing.paddingMd,
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Icon(LucideIcons.puzzle),
              const SizedBox(width: 8),
              Text(
                'Plugins',
                style: theme.textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(LucideIcons.x),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Statistics
          Card(
            child: Padding(
              padding: AppSpacing.paddingMd,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _PluginStatItem(
                    label: 'Active',
                    value: activePlugins.length.toString(),
                    icon: LucideIcons.play,
                  ),
                  _PluginStatItem(
                    label: 'Total',
                    value:
                        pluginManager.getInstalledPlugins().length.toString(),
                    icon: LucideIcons.package,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Plugin list
          Expanded(
            child: ListView.builder(
              itemCount: activePlugins.length,
              itemBuilder: (context, index) {
                final plugin = activePlugins[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(LucideIcons.puzzle),
                    title: Text(plugin.name),
                    subtitle: Text(plugin.description),
                    trailing: PopupMenuButton<String>(
                      onSelected: (command) async {
                        try {
                          final result = await pluginManager.executeCommand(
                            plugin.id,
                            command,
                            <String, dynamic>{},
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result.success
                                      ? 'Command executed successfully'
                                      : 'Command failed: ${result.error}',
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to execute command: $e'),
                                backgroundColor: theme.colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                      itemBuilder: (context) => plugin.capabilities.commands
                          .map(
                            (command) => PopupMenuItem<String>(
                              value: command,
                              child: Text(_formatCommandName(command)),
                            ),
                          )
                          .toList(),
                      child: const Icon(LucideIcons.moreVertical),
                    ),
                  ),
                );
              },
            ),
          ),

          // If no plugins
          if (activePlugins.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No active plugins'),
              ),
            ),
        ],
      ),
    );
  }

  String _formatCommandName(String command) {
    final parts = command.split('.');
    if (parts.length > 1) {
      return parts.last.replaceAll('_', ' ').toUpperCase();
    }
    return command.replaceAll('_', ' ').toUpperCase();
  }
}

class _PluginStatItem extends StatelessWidget {
  const _PluginStatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
