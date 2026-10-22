import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_mvvm_template/core/config/app_stage.dart';

class AppConfig {
  const AppConfig({
    required this.stage,
    required this.appName,
    this.apiBaseUrl,
  });

  final AppStage stage;
  final String appName;
  final String? apiBaseUrl;

  bool get isProd => stage == AppStage.prod;
  bool get isDebugStage => stage != AppStage.prod;

  static Future<AppConfig> load() async {
    final stage = AppStage.parse(
      const String.fromEnvironment('STAGE', defaultValue: 'dev'),
    );
    await dotenv.load(fileName: 'assets/env/${stage.name}.env');
    final baseUrl = dotenv.env['API_BASE_URL']?.trim();
    return AppConfig(
      stage: stage,
      appName: dotenv.env['APP_NAME'] ?? 'Flutter Template',
      apiBaseUrl: (baseUrl == null || baseUrl.isEmpty) ? null : baseUrl,
    );
  }
}
