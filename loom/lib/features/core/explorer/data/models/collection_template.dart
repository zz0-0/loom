import 'package:flutter/material.dart';
import 'package:loom/features/core/explorer/domain/entities/workspace_entities.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// UI model for collection template with icon data
class CollectionTemplateModel extends CollectionTemplate {
  const CollectionTemplateModel({
    required super.id,
    required super.name,
    required super.description,
    required super.icon,
    super.filePatterns,
    super.suggestedFiles,
    super.color,
  });

  /// Convert from domain entity
  factory CollectionTemplateModel.fromDomain(CollectionTemplate domain) =>
      CollectionTemplateModel(
        id: domain.id,
        name: domain.name,
        description: domain.description,
        icon: domain.icon,
        filePatterns: domain.filePatterns,
        suggestedFiles: domain.suggestedFiles,
        color: domain.color,
      );

  /// Convert to domain entity
  CollectionTemplate toDomain() => CollectionTemplate(
        id: id,
        name: name,
        description: description,
        icon: icon,
        filePatterns: filePatterns,
        suggestedFiles: suggestedFiles,
        color: color,
      );

  /// Get the IconData for this template
  IconData get iconData {
    switch (icon) {
      case 'code':
        return LucideIcons.code;
      case 'book':
        return LucideIcons.book;
      case 'file-text':
        return LucideIcons.fileText;
      case 'image':
        return LucideIcons.image;
      case 'settings':
        return LucideIcons.settings;
      case 'users':
        return LucideIcons.users;
      case 'briefcase':
        return LucideIcons.briefcase;
      case 'heart':
        return LucideIcons.heart;
      case 'star':
        return LucideIcons.star;
      case 'folder':
        return LucideIcons.folder;
      default:
        return LucideIcons.star;
    }
  }
}

/// Collection templates utility class
class CollectionTemplatesUtil {
  /// Get domain templates as UI models
  static List<CollectionTemplateModel> getTemplates() {
    return CollectionTemplates.templates
        .map(CollectionTemplateModel.fromDomain)
        .toList();
  }

  /// Get a template by its ID as UI model
  static CollectionTemplateModel? getTemplate(String id) {
    final domainTemplate = CollectionTemplates.getTemplate(id);
    return domainTemplate != null
        ? CollectionTemplateModel.fromDomain(domainTemplate)
        : null;
  }

  /// Get templates as domain entities
  static List<CollectionTemplate> getDomainTemplates() {
    return CollectionTemplates.templates;
  }

  /// Get templates filtered by category as UI models
  static List<CollectionTemplateModel> getTemplatesByCategory(String category) {
    return CollectionTemplates.getTemplatesByCategory(category)
        .map(CollectionTemplateModel.fromDomain)
        .toList();
  }
}
