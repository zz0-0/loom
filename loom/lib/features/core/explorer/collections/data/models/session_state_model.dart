import 'package:loom/features/core/explorer/index.dart';

/// Data model for SessionState
class SessionStateModel extends SessionState {
  const SessionStateModel({
    super.openTabs = const [],
    super.lastActiveFile,
  });

  factory SessionStateModel.fromJson(Map<String, dynamic> json) {
    return SessionStateModel(
      openTabs: List<String>.from(json['openTabs'] as List? ?? []),
      lastActiveFile: json['lastActiveFile'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'openTabs': openTabs,
      'lastActiveFile': lastActiveFile,
    };
  }
}
