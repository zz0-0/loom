import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/explorer/collections/index.dart';
import 'package:loom/features/core/search/index.dart';

// Use case providers
final searchInWorkspaceUseCaseProvider =
    Provider<SearchInWorkspaceUseCase>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchInWorkspaceUseCase(repository);
});

final searchInOpenFilesUseCaseProvider =
    Provider<SearchInOpenFilesUseCase>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchInOpenFilesUseCase(repository);
});

final searchInFileUseCaseProvider = Provider<SearchInFileUseCase>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchInFileUseCase(repository);
});

final manageRecentSearchesUseCaseProvider =
    Provider<ManageRecentSearchesUseCase>((ref) {
  final repository = ref.watch(recentSearchesRepositoryProvider);
  return ManageRecentSearchesUseCase(repository);
});

final replaceInWorkspaceUseCaseProvider =
    Provider<ReplaceInWorkspaceUseCase>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return ReplaceInWorkspaceUseCase(repository);
});

final replaceInFileUseCaseProvider = Provider<ReplaceInFileUseCase>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return ReplaceInFileUseCase(repository);
});

// Search state
class SearchState {
  const SearchState({
    this.isSearching = false,
    this.results,
    this.error,
    this.recentSearches = const [],
  });
  final bool isSearching;
  final SearchResults? results;
  final String? error;
  final List<SearchQuery> recentSearches;

  SearchState copyWith({
    bool? isSearching,
    SearchResults? results,
    String? error,
    List<SearchQuery>? recentSearches,
  }) {
    return SearchState(
      isSearching: isSearching ?? this.isSearching,
      results: results ?? this.results,
      error: error ?? this.error,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

// Search notifier
class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier(
    this._searchInWorkspaceUseCase,
    this._manageRecentSearchesUseCase,
    this._replaceInWorkspaceUseCase,
    this._currentWorkspace,
  ) : super(const SearchState()) {
    _loadRecentSearches();
  }
  final SearchInWorkspaceUseCase _searchInWorkspaceUseCase;
  final ManageRecentSearchesUseCase _manageRecentSearchesUseCase;
  final ReplaceInWorkspaceUseCase _replaceInWorkspaceUseCase;
  final Workspace? _currentWorkspace;

  Future<void> _loadRecentSearches() async {
    try {
      final recentSearches =
          await _manageRecentSearchesUseCase.getRecentSearches();
      state = state.copyWith(recentSearches: recentSearches);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> search(SearchQuery query) async {
    if (query.searchText.trim().isEmpty) return;

    state = state.copyWith(isSearching: true);

    try {
      final results = await _searchInWorkspaceUseCase.execute(
        query,
        workspacePath: _currentWorkspace?.rootPath,
      );
      state = state.copyWith(
        isSearching: false,
        results: results,
      );

      // Save to recent searches
      await _manageRecentSearchesUseCase.saveRecentSearch(query);
      await _loadRecentSearches();
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: e.toString(),
      );
    }
  }

  Future<void> replace(
    SearchQuery query,
    String replaceText, {
    bool replaceAll = false,
  }) async {
    if (query.searchText.trim().isEmpty) return;

    state = state.copyWith(isSearching: true);

    try {
      final results = await _replaceInWorkspaceUseCase.execute(
        query,
        replaceText,
        replaceAll: replaceAll,
        workspacePath: _currentWorkspace?.rootPath,
      );
      state = state.copyWith(
        isSearching: false,
        results: results,
      );

      // Save to recent searches
      await _manageRecentSearchesUseCase.saveRecentSearch(query);
      await _loadRecentSearches();
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: e.toString(),
      );
    }
  }

  void clearResults() {
    // Reset results and loading flag to avoid stale loading states
    state = state.copyWith(
      isSearching: false,
    );
  }

  Future<void> clearRecentSearches() async {
    await _manageRecentSearchesUseCase.clearRecentSearches();
    state = state.copyWith(recentSearches: []);
  }
}

// Search provider
final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final searchUseCase = ref.watch(searchInWorkspaceUseCaseProvider);
  final replaceUseCase = ref.watch(replaceInWorkspaceUseCaseProvider);
  final manageSearchesUseCase = ref.watch(manageRecentSearchesUseCaseProvider);
  final currentWorkspace = ref.watch(currentWorkspaceProvider);
  return SearchNotifier(
    searchUseCase,
    manageSearchesUseCase,
    replaceUseCase,
    currentWorkspace,
  );
});
