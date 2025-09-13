import 'package:loom/features/core/settings/index.dart';

/// Use case for getting application information
class GetAppInfoUseCaseImpl implements GetAppInfoUseCase {
  const GetAppInfoUseCaseImpl(this.repository);

  final AppInfoRepository repository;

  @override
  Future<AppInfo> execute() {
    return repository.getAppInfo();
  }

  @override
  bool canExecute() => true;
}

/// Abstract class for interface
abstract class GetAppInfoUseCase {
  Future<AppInfo> execute();
  bool canExecute() => true;
}
