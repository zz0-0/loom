import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:loom/features/search/domain/entities/search_entities.dart';
import 'package:loom/features/search/presentation/providers/search_provider.dart';

/// Global search dialog
class GlobalSearchDialog extends ConsumerStatefulWidget {
  const GlobalSearchDialog({super.key});

  @override
  ConsumerState<GlobalSearchDialog> createState() => _GlobalSearchDialogState();
}

class _GlobalSearchDialogState extends ConsumerState<GlobalSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
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
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.search, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Global Search',
                  style: theme.textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search input
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search for text...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _caseSensitive
                            ? Icons.text_fields
                            : Icons.text_fields_outlined,
                        size: 18,
                      ),
                      onPressed: () =>
                          setState(() => _caseSensitive = !_caseSensitive),
                      tooltip: 'Case sensitive',
                    ),
                    IconButton(
                      icon: Icon(
                        _useRegex ? Icons.code : Icons.code_outlined,
                        size: 18,
                      ),
                      onPressed: () => setState(() => _useRegex = !_useRegex),
                      tooltip: 'Use regex',
                    ),
                  ],
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
            const SizedBox(height: 8),

            // Search options
            Wrap(
              spacing: 16,
              children: [
                FilterChip(
                  label: const Text('Include hidden files'),
                  selected: _includeHiddenFiles,
                  onSelected: (selected) =>
                      setState(() => _includeHiddenFiles = selected),
                ),
                // File extension filters could be added here
              ],
            ),
            const SizedBox(height: 16),

            // Search button
            ElevatedButton.icon(
              onPressed: searchState.isSearching ? null : _performSearch,
              icon: searchState.isSearching
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(searchState.isSearching ? 'Searching...' : 'Search'),
            ),
            const SizedBox(height: 16),

            // Results
            Expanded(
              child: _buildResults(context, searchState, theme),
            ),

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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                Icons.description,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.fileName,
                  style: theme.textTheme.bodyMedium?.copyWith(
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
        const SizedBox(height: 4),

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
        // TODO(user): Navigate to file and line
        // This would need integration with the tab/file opening system
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
            const SizedBox(height: 2),

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
}
