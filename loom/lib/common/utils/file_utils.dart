import 'dart:io';

import 'package:loom/features/core/explorer/index.dart';
import 'package:path/path.dart' as path;

/// Shared file utilities for common file system operations
class FileUtils {
  /// Get supported file extensions
  static Set<String> getSupportedExtensions() {
    return {'.md', '.markdown', '.blox', '.txt'};
  }

  /// Check if file extension is supported
  static bool isSupportedFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return getSupportedExtensions().contains(extension);
  }

  /// Check if file should be hidden
  static bool isHiddenFile(String filePath, {bool showHiddenFiles = false}) {
    if (showHiddenFiles) return false;

    final fileName = path.basename(filePath);
    return fileName.startsWith('.') ||
        fileName.startsWith('~') ||
        fileName == 'Thumbs.db' ||
        fileName == 'Desktop.ini';
  }

  /// Build file tree from directory
  static Future<List<FileTreeNode>> buildFileTree(
    String directoryPath, {
    bool filterExtensions = true,
    bool showHiddenFiles = false,
    Set<String>? expandedPaths,
  }) async {
    try {
      final directory = Directory(directoryPath);
      if (!directory.existsSync()) {
        return [];
      }

      List<FileSystemEntity> entities;
      try {
        entities = await directory.list().toList();
      } catch (e) {
        // Could not list directory (permission issues, removed dir, etc.)
        return [];
      }
      final nodes = <FileTreeNode>[];

      // Sort: directories first, then files, alphabetically
      entities.sort((a, b) {
        final aIsDir = a is Directory;
        final bIsDir = b is Directory;

        if (aIsDir && !bIsDir) return -1;
        if (!aIsDir && bIsDir) return 1;

        return path
            .basename(a.path)
            .toLowerCase()
            .compareTo(path.basename(b.path).toLowerCase());
      });

      for (final entity in entities) {
        final entityPath = entity.path;
        final entityName = path.basename(entityPath);

        // Skip hidden files if not showing them
        if (isHiddenFile(entityPath, showHiddenFiles: showHiddenFiles)) {
          continue;
        }

        if (entity is Directory) {
          final isExpanded = expandedPaths?.contains(entityPath) ?? false;
          final children = isExpanded
              ? await buildFileTree(
                  entityPath,
                  filterExtensions: filterExtensions,
                  showHiddenFiles: showHiddenFiles,
                  expandedPaths: expandedPaths,
                )
              : <FileTreeNode>[];

          // statSync can throw (permission denied, deleted concurrently).
          DateTime? lastModified;
          try {
            lastModified = entity.statSync().modified;
          } catch (_) {
            // Skip entries we can't stat
            continue;
          }

          nodes.add(
            FileTreeNode(
              name: entityName,
              path: entityPath,
              type: FileTreeNodeType.directory,
              isExpanded: isExpanded,
              children: children,
              lastModified: lastModified,
            ),
          );
        } else if (entity is File) {
          // Apply file extension filter
          if (filterExtensions && !isSupportedFile(entityPath)) {
            continue;
          }
          // statSync can throw (permission denied, removed). Skip on error.
          try {
            final stat = entity.statSync();
            nodes.add(
              FileTreeNode(
                name: entityName,
                path: entityPath,
                type: FileTreeNodeType.file,
                lastModified: stat.modified,
                size: stat.size,
              ),
            );
          } catch (_) {
            continue;
          }
        }
      }

      return nodes;
    } catch (e) {
      return [];
    }
  }
}
