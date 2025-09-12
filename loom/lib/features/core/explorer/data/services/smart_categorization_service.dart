import 'dart:io';

import 'package:loom/features/core/explorer/index.dart';
import 'package:path/path.dart' as path;

/// Service for smart categorization of files and directories
class SmartCategorizationService {
  /// Categorize a file based on its path, extension, and content
  Future<FileCategory> categorizeFile(String filePath) async {
    final fileName = path.basename(filePath);
    final extension = path.extension(filePath).toLowerCase();

    // Check if it's a directory
    if (await FileSystemEntity.isDirectory(filePath)) {
      return _categorizeDirectory(filePath);
    }

    // Categorize based on file extension
    return _categorizeByExtension(extension, fileName);
  }

  /// Categorize a directory based on its contents and name
  FileCategory _categorizeDirectory(String dirPath) {
    final dirName = path.basename(dirPath).toLowerCase();

    // Common directory patterns
    if (dirName.contains('src') || dirName.contains('source')) {
      return FileCategory.development;
    }
    if (dirName.contains('doc') ||
        dirName.contains('docs') ||
        dirName.contains('documentation')) {
      return FileCategory.documentation;
    }
    if (dirName.contains('test') || dirName.contains('tests')) {
      return FileCategory.development;
    }
    if (dirName.contains('asset') ||
        dirName.contains('assets') ||
        dirName.contains('image') ||
        dirName.contains('images') ||
        dirName.contains('media')) {
      return FileCategory.media;
    }
    if (dirName.contains('config') || dirName.contains('conf')) {
      return FileCategory.configuration;
    }
    if (dirName.contains('lib') ||
        dirName.contains('library') ||
        dirName.contains('package') ||
        dirName.contains('packages')) {
      return FileCategory.development;
    }

    return FileCategory.miscellaneous;
  }

  /// Categorize based on file extension
  FileCategory _categorizeByExtension(String extension, String fileName) {
    // Development files
    if (_isDevelopmentExtension(extension)) {
      return FileCategory.development;
    }

    // Documentation files
    if (_isDocumentationExtension(extension)) {
      return FileCategory.documentation;
    }

    // Media files
    if (_isMediaExtension(extension)) {
      return FileCategory.media;
    }

    // Configuration files
    if (_isConfigurationExtension(extension)) {
      return FileCategory.configuration;
    }

    // Archive files
    if (_isArchiveExtension(extension)) {
      return FileCategory.archive;
    }

    // Check for special file names
    if (_isSpecialFile(fileName)) {
      return FileCategory.configuration;
    }

    return FileCategory.miscellaneous;
  }

  /// Check if extension belongs to development files
  bool _isDevelopmentExtension(String extension) {
    const devExtensions = {
      '.dart',
      '.js',
      '.ts',
      '.jsx',
      '.tsx',
      '.py',
      '.java',
      '.cpp',
      '.c',
      '.h',
      '.hpp',
      '.cs',
      '.php',
      '.rb',
      '.swift',
      '.kt',
      '.scala',
      '.clj',
      '.hs',
      '.ml',
      '.fs',
      '.rs',
      '.go',
      '.lua',
      '.pl',
      '.pm',
      '.tcl',
      '.r',
      '.m',
      '.vb',
      '.fsx',
      '.elm',
      '.ex',
      '.exs',
      '.nim',
      '.cr',
      '.zig',
      '.v',
      '.jar',
      '.cljs',
    };
    return devExtensions.contains(extension);
  }

  /// Check if extension belongs to documentation files
  bool _isDocumentationExtension(String extension) {
    const docExtensions = {
      '.md',
      '.txt',
      '.rst',
      '.adoc',
      '.tex',
      '.pdf',
      '.doc',
      '.docx',
      '.rtf',
      '.odt',
      '.wiki',
    };
    return docExtensions.contains(extension);
  }

  /// Check if extension belongs to media files
  bool _isMediaExtension(String extension) {
    const mediaExtensions = {
      '.png',
      '.jpg',
      '.jpeg',
      '.gif',
      '.svg',
      '.webp',
      '.ico',
      '.bmp',
      '.tiff',
      '.tif',
      '.psd',
      '.ai',
      '.xd',
      '.fig',
      '.sketch',
      '.afdesign',
      '.afphoto',
      '.mp4',
      '.avi',
      '.mov',
      '.wmv',
      '.flv',
      '.webm',
      '.mkv',
      '.mp3',
      '.wav',
      '.flac',
      '.aac',
      '.ogg',
      '.wma',
      '.midi',
      '.mid',
    };
    return mediaExtensions.contains(extension);
  }

  /// Check if extension belongs to configuration files
  bool _isConfigurationExtension(String extension) {
    const configExtensions = {
      '.json',
      '.yaml',
      '.yml',
      '.toml',
      '.xml',
      '.ini',
      '.cfg',
      '.conf',
      '.config',
      '.properties',
      '.env',
      '.envrc',
      '.sh',
      '.bat',
      '.ps1',
      '.gradle',
      '.pom',
      '.dockerfile',
      '.makefile',
      '.cmake',
    };
    return configExtensions.contains(extension);
  }

  /// Check if extension belongs to archive files
  bool _isArchiveExtension(String extension) {
    const archiveExtensions = {
      '.zip',
      '.rar',
      '.7z',
      '.tar',
      '.gz',
      '.bz2',
      '.xz',
      '.tgz',
      '.tbz2',
    };
    return archiveExtensions.contains(extension);
  }

  /// Check if file is a special configuration file
  bool _isSpecialFile(String fileName) {
    const specialFiles = {
      'readme',
      'changelog',
      'contributing',
      'license',
      'authors',
      'contributors',
      'dockerfile',
      'makefile',
      'cmakelists.txt',
      'package.json',
      'tsconfig.json',
      'jsconfig.json',
      '.eslintrc',
      '.prettierrc',
      '.gitignore',
      '.gitattributes',
      'docker-compose.yml',
      'docker-compose.yaml',
    };

    final lowerFileName = fileName.toLowerCase();
    return specialFiles.any(lowerFileName.contains);
  }

  /// Get suggested collection templates for a file
  List<String> getSuggestedCollections(String filePath) {
    final fileName = path.basename(filePath).toLowerCase();
    final extension = path.extension(filePath).toLowerCase();

    final suggestions = <String>[];

    // Development files
    if (_isDevelopmentExtension(extension)) {
      suggestions.add('development');
    }

    // Documentation
    if (_isDocumentationExtension(extension) || fileName.contains('readme')) {
      suggestions.add('documentation');
    }

    // Design/Media
    if (_isMediaExtension(extension)) {
      suggestions.add('design');
    }

    // Configuration
    if (_isConfigurationExtension(extension) || _isSpecialFile(fileName)) {
      suggestions.add('configuration');
    }

    // Work-related
    if (fileName.contains('report') ||
        fileName.contains('meeting') ||
        fileName.contains('presentation')) {
      suggestions.add('work');
    }

    // Research
    if (fileName.contains('paper') ||
        fileName.contains('research') ||
        fileName.contains('study')) {
      suggestions.add('research');
    }

    // Personal
    if (fileName.contains('note') ||
        fileName.contains('journal') ||
        fileName.contains('diary')) {
      suggestions.add('personal');
    }

    // Archive
    if (fileName.contains('archive') ||
        fileName.contains('old') ||
        fileName.contains('backup')) {
      suggestions.add('archive');
    }

    return suggestions;
  }

  /// Analyze directory contents and suggest categorization
  Future<Map<String, dynamic>> analyzeDirectory(String dirPath) async {
    final dir = Directory(dirPath);
    final files = <String>[];
    final categories = <FileCategory, int>{};

    try {
      await for (final entity in dir.list()) {
        if (entity is File) {
          files.add(entity.path);
          final category = await categorizeFile(entity.path);
          categories[category] = (categories[category] ?? 0) + 1;
        }
      }
    } catch (e) {
      // Handle permission errors or other issues
      return {
        'error': e.toString(),
        'files': <String>[],
        'categories': <FileCategory, int>{},
        'suggestions': <String>[],
      };
    }

    // Generate suggestions based on category distribution
    final suggestions = <String>[];
    final totalFiles = files.length;

    if (totalFiles == 0) {
      return {
        'files': files,
        'categories': categories,
        'suggestions': <String>['empty'],
      };
    }

    final devPercentage =
        (categories[FileCategory.development] ?? 0) / totalFiles;
    final docPercentage =
        (categories[FileCategory.documentation] ?? 0) / totalFiles;
    final mediaPercentage = (categories[FileCategory.media] ?? 0) / totalFiles;

    if (devPercentage > 0.5) {
      suggestions.add('development');
    }
    if (docPercentage > 0.3) {
      suggestions.add('documentation');
    }
    if (mediaPercentage > 0.3) {
      suggestions.add('design');
    }

    return {
      'files': files,
      'categories': categories,
      'suggestions': suggestions,
    };
  }
}
