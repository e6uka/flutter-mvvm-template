import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_mvvm_template/core/config/app_config.dart';
import 'package:flutter_mvvm_template/core/config/app_stage.dart';
import 'package:flutter_mvvm_template/repositories/announcement_repository.dart';
import 'package:flutter_mvvm_template/repositories/fake_auth_repository.dart';
import 'package:flutter_mvvm_template/repositories/fake_announcement_repository.dart';
import 'package:flutter_mvvm_template/store/providers.dart';
import 'package:flutter_mvvm_template/theme/app_colors.dart';
import 'package:flutter_mvvm_template/theme/brand_palette.dart';

const testConfig = AppConfig(stage: AppStage.dev, appName: 'Flutter Template');

List<Override> testOverrides({AnnouncementRepository? announcements}) {
  AppColors.install(BrandPalette.app);
  return [
    appConfigProvider.overrideWithValue(testConfig),
    authRepositoryProvider.overrideWithValue(
      FakeAuthRepository(latency: Duration.zero),
    ),
    announcementRepositoryProvider.overrideWithValue(
      announcements ?? FakeAnnouncementRepository(latency: Duration.zero),
    ),
  ];
}

ProviderContainer makeContainer({AnnouncementRepository? announcements}) {
  final container = ProviderContainer(
    overrides: testOverrides(announcements: announcements),
  );
  return container;
}
