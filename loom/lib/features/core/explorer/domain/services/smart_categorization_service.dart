import 'package:loom/features/core/explorer/domain/entities/workspace_entities.dart';
import 'package:path/path.dart' as path;

/// Service for smart categorization of files into collections
class SmartCategorizationService {
  /// Get collection suggestions for a file based on its path and type
  static List<CollectionSuggestion> getSuggestionsForFile(String filePath) {
    final fileName = path.basename(filePath);
    final extension = path.extension(fileName).toLowerCase();
    final directory = path.dirname(filePath).toLowerCase();

    final suggestions = <CollectionSuggestion>[];

    // Analyze file extension
    final extensionSuggestions = _getSuggestionsByExtension(extension);
    suggestions.addAll(extensionSuggestions);

    // Analyze directory structure
    final directorySuggestions = _getSuggestionsByDirectory(directory);
    suggestions.addAll(directorySuggestions);

    // Analyze file name patterns
    final nameSuggestions = _getSuggestionsByName(fileName);
    suggestions.addAll(nameSuggestions);

    // Remove duplicates and sort by confidence
    final uniqueSuggestions = <String, CollectionSuggestion>{};
    for (final suggestion in suggestions) {
      if (!uniqueSuggestions.containsKey(suggestion.templateId) ||
          uniqueSuggestions[suggestion.templateId]!.confidence <
              suggestion.confidence) {
        uniqueSuggestions[suggestion.templateId] = suggestion;
      }
    }

    return uniqueSuggestions.values.toList()
      ..sort((a, b) => b.confidence.compareTo(a.confidence));
  }

  /// Get suggestions based on file extension
  static List<CollectionSuggestion> _getSuggestionsByExtension(
    String extension,
  ) {
    final suggestions = <CollectionSuggestion>[];

    switch (extension) {
      // Development files
      case '.dart':
      case '.js':
      case '.ts':
      case '.py':
      case '.java':
      case '.cpp':
      case '.c':
      case '.h':
      case '.rs':
      case '.go':
      case '.php':
      case '.rb':
      case '.swift':
      case '.kt':
      case '.scala':
      case '.clj':
      case '.hs':
      case '.ml':
      case '.fs':
      case '.cs':
      case '.vb':
        suggestions.add(
          const CollectionSuggestion(
            templateId: 'development',
            confidence: 0.9,
            reason: 'Code file detected',
          ),
        );

      // Documentation files
      case '.md':
      case '.txt':
      case '.rst':
      case '.adoc':
        suggestions.add(
          const CollectionSuggestion(
            templateId: 'documentation',
            confidence: 0.8,
            reason: 'Documentation file detected',
          ),
        );

      // Design assets
      case '.png':
      case '.jpg':
      case '.jpeg':
      case '.gif':
      case '.svg':
      case '.webp':
      case '.ico':
      case '.psd':
      case '.ai':
      case '.xd':
      case '.fig':
      case '.sketch':
        suggestions.add(
          const CollectionSuggestion(
            templateId: 'design',
            confidence: 0.9,
            reason: 'Design asset detected',
          ),
        );

      // Configuration files
      case '.json':
      case '.yaml':
      case '.yml':
      case '.toml':
      case '.xml':
      case '.ini':
      case '.cfg':
      case '.conf':
      case '.env':
        suggestions.add(
          const CollectionSuggestion(
            templateId: 'configuration',
            confidence: 0.7,
            reason: 'Configuration file detected',
          ),
        );

      // Research files
      case '.pdf':
        suggestions.add(
          const CollectionSuggestion(
            templateId: 'research',
            confidence: 0.6,
            reason: 'Document file detected',
          ),
        );
    }

    return suggestions;
  }

  /// Get suggestions based on directory structure
  static List<CollectionSuggestion> _getSuggestionsByDirectory(
    String directory,
  ) {
    final suggestions = <CollectionSuggestion>[];

    if (directory.contains('doc') ||
        directory.contains('docs') ||
        directory.contains('documentation')) {
      suggestions.add(
        const CollectionSuggestion(
          templateId: 'documentation',
          confidence: 0.8,
          reason: 'Located in documentation directory',
        ),
      );
    }

    if (directory.contains('src') ||
        directory.contains('source') ||
        directory.contains('lib')) {
      suggestions.add(
        const CollectionSuggestion(
          templateId: 'development',
          confidence: 0.7,
          reason: 'Located in source directory',
        ),
      );
    }

    if (directory.contains('asset') ||
        directory.contains('image') ||
        directory.contains('img')) {
      suggestions.add(
        const CollectionSuggestion(
          templateId: 'design',
          confidence: 0.8,
          reason: 'Located in assets directory',
        ),
      );
    }

    if (directory.contains('config') || directory.contains('conf')) {
      suggestions.add(
        const CollectionSuggestion(
          templateId: 'configuration',
          confidence: 0.7,
          reason: 'Located in configuration directory',
        ),
      );
    }

    if (directory.contains('research') ||
        directory.contains('paper') ||
        directory.contains('study')) {
      suggestions.add(
        const CollectionSuggestion(
          templateId: 'research',
          confidence: 0.7,
          reason: 'Located in research directory',
        ),
      );
    }

    if (directory.contains('note') ||
        directory.contains('journal') ||
        directory.contains('diary')) {
      suggestions.add(
        const CollectionSuggestion(
          templateId: 'personal',
          confidence: 0.6,
          reason: 'Located in notes directory',
        ),
      );
    }

    if (directory.contains('work') || directory.contains('project')) {
      suggestions.add(
        const CollectionSuggestion(
          templateId: 'work',
          confidence: 0.6,
          reason: 'Located in work directory',
        ),
      );
    }

    if (directory.contains('archive') ||
        directory.contains('archived') ||
        directory.contains('old')) {
      suggestions.add(
        const CollectionSuggestion(
          templateId: 'archive',
          confidence: 0.8,
          reason: 'Located in archive directory',
        ),
      );
    }

    return suggestions;
  }

  /// Get suggestions based on file name patterns
  static List<CollectionSuggestion> _getSuggestionsByName(String fileName) {
    final suggestions = <CollectionSuggestion>[];
    final lowerName = fileName.toLowerCase();

    // Documentation patterns
    if (lowerName.contains('readme') ||
        lowerName.contains('changelog') ||
        lowerName.contains('contributing') ||
        lowerName.contains('license')) {
      suggestions.add(
        const CollectionSuggestion(
          templateId: 'documentation',
          confidence: 0.9,
          reason: 'Standard documentation file name',
        ),
      );
    }

    // Configuration patterns
    if (lowerName.startsWith('.') ||
        lowerName.contains('config') ||
        lowerName.contains('settings') ||
        lowerName.contains('env')) {
      suggestions.add(
        const CollectionSuggestion(
          templateId: 'configuration',
          confidence: 0.8,
          reason: 'Configuration file pattern detected',
        ),
      );
    }

    // Personal/Work patterns
    if (lowerName.contains('note') ||
        lowerName.contains('journal') ||
        lowerName.contains('diary') ||
        lowerName.contains('todo')) {
      suggestions.add(
        const CollectionSuggestion(
          templateId: 'personal',
          confidence: 0.7,
          reason: 'Personal file pattern detected',
        ),
      );
    }

    return suggestions;
  }

  /// Get the top N suggestions for a file
  static List<CollectionSuggestion> getTopSuggestions(
    String filePath, {
    int limit = 3,
  }) {
    final allSuggestions = getSuggestionsForFile(filePath);
    return allSuggestions.take(limit).toList();
  }

  /// Check if a file matches a collection template's patterns
  static bool fileMatchesTemplate(
    String filePath,
    CollectionTemplate template,
  ) {
    if (template.filePatterns.isEmpty) return false;

    final fileName = path.basename(filePath);
    final extension = path.extension(fileName).toLowerCase();
    final directory = path.dirname(filePath).toLowerCase();

    for (final pattern in template.filePatterns) {
      // Simple pattern matching (could be enhanced with glob matching)
      if (pattern.startsWith('*.')) {
        final patternExt = pattern.substring(2).toLowerCase();
        if (extension == '.$patternExt') {
          return true;
        }
      } else if (pattern.contains('/**')) {
        final dirPattern = pattern.split('/**')[0].toLowerCase();
        if (directory.contains(dirPattern)) {
          return true;
        }
      } else if (directory.contains(pattern.toLowerCase()) ||
          fileName.toLowerCase().contains(pattern.toLowerCase())) {
        return true;
      }
    }

    return false;
  }
}

/// Represents a collection suggestion for a file
class CollectionSuggestion {
  const CollectionSuggestion({
    required this.templateId,
    required this.confidence,
    required this.reason,
  });

  /// The template ID this suggestion is for
  final String templateId;

  /// Confidence score (0.0 to 1.0)
  final double confidence;

  /// Human-readable reason for the suggestion
  final String reason;

  /// Get the template associated with this suggestion
  CollectionTemplate? get template =>
      CollectionTemplates.getTemplate(templateId);

  /// Get the display name for this suggestion
  String get displayName => template?.name ?? templateId;

  /// Get the icon for this suggestion
  String? get icon => template?.icon;

  /// Get the color for this suggestion
  String? get color => template?.color;
}
