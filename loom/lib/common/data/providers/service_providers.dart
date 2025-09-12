import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';

/// File content service provider
final fileContentServiceProvider = Provider<FileContentService>(
  (ref) => FileContentServiceImpl(),
);

/// Edit history service provider
final editHistoryServiceProvider = Provider<EditHistoryService>(
  (ref) => EditHistoryServiceImpl(),
);

/// Code folding service provider
final codeFoldingServiceProvider = Provider<CodeFoldingService>(
  (ref) => CodeFoldingServiceImpl(),
);
