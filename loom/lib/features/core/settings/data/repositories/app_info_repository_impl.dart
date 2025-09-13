import 'package:loom/features/core/settings/index.dart';

/// Implementation of app info repository
class AppInfoRepositoryImpl implements AppInfoRepository {
  @override
  Future<AppInfo> getAppInfo() async {
    return const AppInfo(
      name: 'Loom',
      version: '1.0.0',
      buildNumber: '1',
      description: 'A knowledge base application',
    );
  }
}
