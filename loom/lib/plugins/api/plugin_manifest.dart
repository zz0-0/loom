import 'dart:convert';

/// Represents a plugin manifest that defines metadata and configuration for a plugin
class PluginManifest {
  const PluginManifest({
    required this.id,
    required this.name,
    required this.version,
    required this.description,
    required this.author,
    required this.entryPoint,
    required this.permissions,
    required this.metadata,
    required this.dependencies,
    required this.capabilities,
    this.icon,
  });

  factory PluginManifest.fromJson(Map<String, dynamic> json) {
    return PluginManifest(
      id: json['id'] as String,
      name: json['name'] as String,
      version: json['version'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
      entryPoint: json['entryPoint'] as String,
      permissions:
          List<String>.from(json['permissions'] as List<dynamic>? ?? []),
      metadata: Map<String, dynamic>.from(
        json['metadata'] as Map<dynamic, dynamic>? ?? {},
      ),
      dependencies: PluginDependencies.fromJson(
        json['dependencies'] as Map<String, dynamic>? ?? {},
      ),
      capabilities: PluginCapabilities.fromJson(
        json['capabilities'] as Map<String, dynamic>? ?? {},
      ),
      icon: json['icon'] as String?,
    );
  }
  final String id;
  final String name;
  final String version;
  final String description;
  final String author;
  final String entryPoint;
  final List<String> permissions;
  final Map<String, dynamic> metadata;
  final PluginDependencies dependencies;
  final PluginCapabilities capabilities;
  final String? icon;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'description': description,
      'author': author,
      'entryPoint': entryPoint,
      'permissions': permissions,
      'metadata': metadata,
      'dependencies': dependencies.toJson(),
      'capabilities': capabilities.toJson(),
      if (icon != null) 'icon': icon,
    };
  }
}

/// Represents plugin dependencies
class PluginDependencies {
  const PluginDependencies({
    required this.plugins,
    required this.packages,
  });

  factory PluginDependencies.fromJson(Map<String, dynamic> json) {
    return PluginDependencies(
      plugins: List<String>.from(json['plugins'] as List<dynamic>? ?? []),
      packages: Map<String, String>.from(
        json['packages'] as Map<dynamic, dynamic>? ?? {},
      ),
    );
  }
  final List<String> plugins;
  final Map<String, String> packages;

  Map<String, dynamic> toJson() {
    return {
      'plugins': plugins,
      'packages': packages,
    };
  }
}

/// Represents plugin capabilities
class PluginCapabilities {
  const PluginCapabilities({
    required this.hooks,
    required this.commands,
    required this.fileExtensions,
    required this.customCapabilities,
  });

  factory PluginCapabilities.fromJson(Map<String, dynamic> json) {
    return PluginCapabilities(
      hooks: List<String>.from(json['hooks'] as List<dynamic>? ?? []),
      commands: List<String>.from(json['commands'] as List<dynamic>? ?? []),
      fileExtensions:
          List<String>.from(json['fileExtensions'] as List<dynamic>? ?? []),
      customCapabilities: Map<String, dynamic>.from(
        json['customCapabilities'] as Map<dynamic, dynamic>? ?? {},
      ),
    );
  }
  final List<String> hooks;
  final List<String> commands;
  final List<String> fileExtensions;
  final Map<String, dynamic> customCapabilities;

  Map<String, dynamic> toJson() {
    return {
      'hooks': hooks,
      'commands': commands,
      'fileExtensions': fileExtensions,
      'customCapabilities': customCapabilities,
    };
  }
}

/// Service for parsing and validating plugin manifests
class PluginManifestParser {
  /// Parses a plugin manifest from JSON string
  static PluginManifest parse(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return PluginManifest.fromJson(json);
    } catch (e) {
      throw PluginManifestParseException('Failed to parse manifest: $e');
    }
  }

  /// Validates a plugin manifest
  static List<String> validate(PluginManifest manifest) {
    final errors = <String>[];

    // Validate required fields
    if (manifest.id.isEmpty) {
      errors.add('Plugin ID cannot be empty');
    }

    if (manifest.name.isEmpty) {
      errors.add('Plugin name cannot be empty');
    }

    if (manifest.version.isEmpty) {
      errors.add('Plugin version cannot be empty');
    }

    if (manifest.entryPoint.isEmpty) {
      errors.add('Plugin entry point cannot be empty');
    }

    // Validate version format (basic semantic versioning)
    final versionRegex = RegExp(r'^\d+\.\d+\.\d+$');
    if (!versionRegex.hasMatch(manifest.version)) {
      errors.add('Plugin version must follow semantic versioning (x.y.z)');
    }

    // Validate permissions
    final validPermissions = [
      'filesystem.read',
      'filesystem.write',
      'network.http',
      'network.websocket',
      'ui.dialog',
      'ui.notification',
      'system.command',
    ];

    for (final permission in manifest.permissions) {
      if (!validPermissions.contains(permission)) {
        errors.add('Invalid permission: $permission');
      }
    }

    return errors;
  }
}

/// Exception thrown when plugin manifest parsing fails
class PluginManifestParseException implements Exception {
  PluginManifestParseException(this.message);
  final String message;

  @override
  String toString() => 'PluginManifestParseException: $message';
}
