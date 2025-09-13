import 'package:loom/features/core/explorer/domain/entities/workspace_entities.dart';

/// Domain entities for collection suggestions

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
