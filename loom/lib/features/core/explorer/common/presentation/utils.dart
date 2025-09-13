import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Utility to convert icon strings to IconData
IconData getIconDataFromString(String? iconName) {
  switch (iconName) {
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
