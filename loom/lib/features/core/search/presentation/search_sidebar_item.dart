import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/search/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

/// Search sidebar item that opens search in the side panel
class SearchSidebarItem implements SidebarItem {
  @override
  String get id => 'search';

  @override
  IconData get icon => Icons.search;

  @override
  String? get tooltip => null; // Handled by ExtensibleSidebar for localization

  @override
  VoidCallback? get onPressed => null; // Use default panel behavior

  @override
  Widget? buildPanel(BuildContext context) {
    return const SearchPanel();
  }
}

/// Search panel that appears in the side panel
class SearchPanel extends ConsumerStatefulWidget {
  const SearchPanel({super.key});

  @override
  ConsumerState<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends ConsumerState<SearchPanel> {
  final TextEditingController _searchController = TextEditingController();
  SearchMode _currentMode = SearchMode.content;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchState = ref.watch(searchProvider);

    final localizations = AppLocalizations.of(context);

    return Container(
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search input field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: localizations.sidebarSearchPlaceholder,
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              prefixIcon: const Icon(Icons.search, size: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              isDense: true,
            ),
            onSubmitted: _performSearch,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Quick search options
          _SearchOption(
            icon: Icons.file_present,
            title: localizations.searchOptionFilesTitle,
            subtitle: localizations.searchOptionFilesSubtitle,
            isSelected: _currentMode == SearchMode.files,
            onTap: () => _setSearchMode(SearchMode.files),
          ),
          const SizedBox(height: AppSpacing.xs),
          _SearchOption(
            icon: Icons.text_fields,
            title: localizations.searchOptionContentTitle,
            subtitle: localizations.searchOptionContentSubtitle,
            isSelected: _currentMode == SearchMode.content,
            onTap: () => _setSearchMode(SearchMode.content),
          ),
          const SizedBox(height: AppSpacing.xs),
          _SearchOption(
            icon: Icons.code,
            title: localizations.searchOptionSymbolsTitle,
            subtitle: localizations.searchOptionSymbolsSubtitle,
            isSelected: _currentMode == SearchMode.symbols,
            onTap: () => _setSearchMode(SearchMode.symbols),
          ),

          // Search results
          if (searchState.results != null || searchState.isSearching) ...[
            const SizedBox(height: AppSpacing.sm),
            const Divider(height: AppSpacing.xs),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: _buildResults(context, searchState, theme),
            ),
          ],
        ],
      ),
    );
  }

  void _setSearchMode(SearchMode mode) {
    setState(() {
      _currentMode = mode;
    });
    // Perform search with new mode if there's a query
    if (_searchController.text.trim().isNotEmpty) {
      _performSearch(_searchController.text.trim());
    }
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    final searchQuery = SearchQuery(
      searchText: query.trim(),
      // Configure search based on mode
      fileExtensions: _getFileExtensionsForMode(),
      // For symbols, we might want to search in code files only
      excludePatterns: _getExcludePatternsForMode(),
    );

    ref.read(searchProvider.notifier).search(searchQuery);
  }

  List<String> _getFileExtensionsForMode() {
    switch (_currentMode) {
      case SearchMode.files:
        // For file search, search all files
        return [];
      case SearchMode.content:
        // For content search, search all files
        return [];
      case SearchMode.symbols:
        // For symbol search, focus on code files
        return ['dart', 'py', 'js', 'ts', 'java', 'cpp', 'c', 'h', 'hpp', 'rs'];
    }
  }

  List<String> _getExcludePatternsForMode() {
    switch (_currentMode) {
      case SearchMode.files:
      case SearchMode.content:
        // Include all files
        return [];
      case SearchMode.symbols:
        // Exclude common non-code directories
        return ['node_modules/**', '.git/**', 'build/**', 'target/**'];
    }
  }

  Widget _buildResults(
    BuildContext context,
    SearchState searchState,
    ThemeData theme,
  ) {
    final localizations = AppLocalizations.of(context);

    if (searchState.isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (searchState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 32,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 8),
            Text(
              // searchError expects an Object parameter (error); use the state's error
              localizations.searchError(searchState.error ?? ''),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            if (searchState.error != null)
              Text(
                searchState.error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      );
    }

    final results = searchState.results;
    if (results == null || results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.noResultsFound,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary
        Text(
          localizations.searchResultsSummary(
            results.totalMatches,
            results.totalFiles,
            results.searchTime.inMilliseconds,
            // results.totalMatches,
          ),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Results list
        Expanded(
          child: ListView.builder(
            itemCount: results.groups.length,
            itemBuilder: (context, index) {
              final group = results.groups[index];
              return _buildResultGroup(group, theme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultGroup(SearchResultsGroup group, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File header
        InkWell(
          onTap: () => _openFile(group.filePath),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xs,
              horizontal: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.description,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    group.fileName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)
                      .matchesInFile(group.totalMatches),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 2),

        // Individual results (show first few)
        ...group.results
            .take(3)
            .map((result) => _buildResultItem(result, theme)),

        // Show "more" indicator if there are more results
        if (group.results.length > 3)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: Text(
              AppLocalizations.of(context)
                  .moreMatches(group.results.length - 3),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildResultItem(SearchResult result, ThemeData theme) {
    return InkWell(
      onTap: () => _openFileAtLine(result.filePath, result.lineNumber),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
          horizontal: AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Line number
            Text(
              AppLocalizations.of(context).linePrefix(result.lineNumber),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Line content with highlighted match
            RichText(
              text: _buildHighlightedText(result, theme),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _buildHighlightedText(SearchResult result, ThemeData theme) {
    final beforeMatch = result.lineContent.substring(0, result.matchStart);
    final match = result.matchedText;
    final afterMatch = result.lineContent.substring(result.matchEnd);

    return TextSpan(
      style: theme.textTheme.bodySmall?.copyWith(
        fontFamily: 'monospace',
      ),
      children: [
        TextSpan(text: beforeMatch),
        TextSpan(
          text: match,
          style: TextStyle(
            backgroundColor: theme.colorScheme.primaryContainer,
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextSpan(text: afterMatch),
      ],
    );
  }

  // IconData _getFileIcon(String fileName) {
  //   final extension = fileName.split('.').last.toLowerCase();

  //   switch (extension) {
  //     case 'dart':
  //       return Icons.code;
  //     case 'py':
  //       return Icons.code;
  //     case 'js':
  //     case 'ts':
  //       return Icons.javascript;
  //     case 'html':
  //       return Icons.html;
  //     case 'css':
  //       return Icons.css;
  //     case 'json':
  //       return Icons.data_object;
  //     case 'md':
  //       return Icons.description;
  //     case 'txt':
  //       return Icons.text_fields;
  //     case 'png':
  //     case 'jpg':
  //     case 'jpeg':
  //     case 'gif':
  //     case 'svg':
  //       return Icons.image;
  //     default:
  //       return Icons.insert_drive_file;
  //   }
  // }

  void _openFile(String filePath) {
    final container = ProviderScope.containerOf(context, listen: false);
    final fileName = filePath.split('/').last;
    container.read(tabProvider.notifier).openTab(
          id: filePath,
          title: fileName,
          contentType: 'file',
        );
  }

  void _openFileAtLine(String filePath, int lineNumber) {
    final container = ProviderScope.containerOf(context, listen: false);
    final fileName = filePath.split('/').last;
    container.read(tabProvider.notifier).openTab(
          id: filePath,
          title: fileName,
          contentType: 'file',
        );
    // TODO(user): Scroll to specific line (requires editor integration)
  }
}

/// Search mode enumeration
enum SearchMode {
  files,
  content,
  symbols,
}

class _SearchOption extends StatelessWidget {
  const _SearchOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isSelected = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusSm,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: isSelected
                ? Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: isSelected
                            ? theme.colorScheme.primary.withOpacity(0.7)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Registration function for the search feature
class SearchFeatureRegistration {
  static void register() {
    final registry = UIRegistry();
    registry.registerSidebarItem(SearchSidebarItem());
  }
}
