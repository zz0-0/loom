class SessionState {
  const SessionState({
    this.openTabs = const [],
    this.lastActiveFile,
  });

  factory SessionState.fromJson(Map<String, dynamic> json) {
    return SessionState(
      openTabs: List<String>.from(json['openTabs'] as List? ?? []),
      lastActiveFile: json['lastActiveFile'] as String?,
    );
  }

  final List<String> openTabs;
  final String? lastActiveFile;

  SessionState copyWith({
    List<String>? openTabs,
    String? lastActiveFile,
  }) {
    return SessionState(
      openTabs: openTabs ?? this.openTabs,
      lastActiveFile: lastActiveFile ?? this.lastActiveFile,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openTabs': openTabs,
      'lastActiveFile': lastActiveFile,
    };
  }
}
