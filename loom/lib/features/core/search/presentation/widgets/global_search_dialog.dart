import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/search/index.dart';

/// Global search dialog
class GlobalSearchDialog extends ConsumerStatefulWidget {
  const GlobalSearchDialog({super.key});

  @override
  ConsumerState<GlobalSearchDialog> createState() => _GlobalSearchDialogState();
}

class _GlobalSearchDialogState extends ConsumerState<GlobalSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _replaceController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _caseSensitive = false;
  bool _useRegex = false;
  bool _includeHiddenFiles = false;
  final List<String> _fileExtensions = [];
  final List<String> _excludePatterns = [];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _replaceController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 700,
        height: 500,
        padding: AppSpacing.paddingSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.search, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 6),
                Text(
                  'Global Search',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ).withHoverAnimation().withPressAnimation(),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Search input
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search for text...',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
                prefixIcon: const Icon(Icons.search, size: 18),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _caseSensitive
                            ? Icons.text_fields
                            : Icons.text_fields_outlined,
                        size: 16,
                      ),
                      onPressed: () =>
                          setState(() => _caseSensitive = !_caseSensitive),
                      tooltip: 'Case sensitive',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                    ).withHoverAnimation().withPressAnimation(),
                    IconButton(
                      icon: Icon(
                        _useRegex ? Icons.code : Icons.code_outlined,
                        size: 16,
                      ),
                      onPressed: () => setState(() => _useRegex = !_useRegex),
                      tooltip: 'Use regex',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                    ).withHoverAnimation().withPressAnimation(),
                  ],
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                isDense: true,
              ),
              onSubmitted: (_) => _performSearch(),
            ),
            const SizedBox(height: AppSpacing.xs),

            // Replace input
            TextField(
              controller: _replaceController,
              decoration: InputDecoration(
                hintText: 'Replace with...',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
                prefixIcon: const Icon(Icons.find_replace, size: 18),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // Search options
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                FilterChip(
                  label: const Text('Include hidden files'),
                  selected: _includeHiddenFiles,
                  onSelected: (selected) =>
                      setState(() => _includeHiddenFiles = selected),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                ),
                // File extension filters could be added here
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Results
            Expanded(
              child: _buildResults(context, searchState, theme),
            ),

            // Replace buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: searchState.isSearching
                        ? null
                        : () => _performReplace(replaceAll: false),
                    icon: searchState.isSearching
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.find_replace, size: 16),
                    label: Text(
                      searchState.isSearching ? 'Replacing...' : 'Replace',
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: searchState.isSearching
                        ? null
                        : () => _performReplace(replaceAll: true),
                    icon: searchState.isSearching
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.find_replace, size: 16),
                    label: Text(
                      searchState.isSearching
                          ? 'Replacing All...'
                          : 'Replace All',
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Recent searches
            if (searchState.recentSearches.isNotEmpty) ...[
              const Divider(),
              Text(
                'Recent Searches',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: searchState.recentSearches.take(5).map((query) {
                  return ActionChip(
                    label: Text(query.searchText),
                    onPressed: () {
                      _searchController.text = query.searchText;
                      setState(() {
                        _caseSensitive = query.caseSensitive;
                        _useRegex = query.useRegex;
                      });
                      _performSearch();
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResults(
    BuildContext context,
    SearchState searchState,
    ThemeData theme,
  ) {
    if (searchState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Error',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              searchState.error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (searchState.results == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Enter search text to find matches',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    final results = searchState.results!;
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No matches found',
              style: theme.textTheme.bodyLarge?.copyWith(
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
          '${results.totalMatches} matches in ${results.totalFiles} files (${results.searchTime.inMilliseconds}ms)',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),

        // Results list
        Expanded(
          child: ListView.builder(
            itemCount: results.groups.length,
            itemBuilder: (context, index) {
              final group = results.groups[index];
              return _buildResultGroup(context, group, theme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultGroup(
    BuildContext context,
    SearchResultsGroup group,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File header
        Container(
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
                ),
              ),
              Text(
                '${group.totalMatches} matches',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),

        // Individual results
        ...group.results
            .map((result) => _buildResultItem(context, result, theme)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildResultItem(
    BuildContext context,
    SearchResult result,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () {
        // Navigate to file and line
        final container = ProviderScope.containerOf(context, listen: false);
        container.read(fileOpeningServiceProvider).openFile(result.filePath);

        // Close the search dialog
        Navigator.of(context).pop();

        // TODO(user): Scroll to specific line (requires editor integration)
        // This would need the editor widget to expose a scrollToLine method
      },
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
              'Line ${result.lineNumber}',
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
      style: theme.textTheme.bodyMedium?.copyWith(
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

  void _performSearch() {
    final query = SearchQuery(
      searchText: _searchController.text.trim(),
      caseSensitive: _caseSensitive,
      useRegex: _useRegex,
      includeHiddenFiles: _includeHiddenFiles,
      fileExtensions: _fileExtensions,
      excludePatterns: _excludePatterns,
    );

    if (query.searchText.isNotEmpty) {
      ref.read(searchProvider.notifier).search(query);
    }
  }

  void _performReplace({required bool replaceAll}) {
    final query = SearchQuery(
      searchText: _searchController.text.trim(),
      caseSensitive: _caseSensitive,
      useRegex: _useRegex,
      includeHiddenFiles: _includeHiddenFiles,
      fileExtensions: _fileExtensions,
      excludePatterns: _excludePatterns,
    );

    if (query.searchText.isNotEmpty) {
      ref.read(searchProvider.notifier).replace(
            query,
            _replaceController.text,
            replaceAll: replaceAll,
          );
    }
  }
}
