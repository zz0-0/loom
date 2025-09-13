/// Permission system for plugins
class PluginPermissions {
  final Set<String> _grantedPermissions = {};

  /// Check if a permission is granted
  bool hasPermission(String permission) {
    return _grantedPermissions.contains(permission);
  }

  /// Grant a permission
  void grantPermission(String permission) {
    _grantedPermissions.add(permission);
  }

  /// Revoke a permission
  void revokePermission(String permission) {
    _grantedPermissions.remove(permission);
  }

  /// Get all granted permissions
  Set<String> get grantedPermissions => Set.unmodifiable(_grantedPermissions);
}
