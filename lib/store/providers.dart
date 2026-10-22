import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_mvvm_template/core/config/app_config.dart';
import 'package:flutter_mvvm_template/repositories/announcement_repository.dart';
import 'package:flutter_mvvm_template/repositories/auth_repository.dart';
import 'package:flutter_mvvm_template/repositories/fake_announcement_repository.dart';
import 'package:flutter_mvvm_template/repositories/fake_auth_repository.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden in bootstrap');
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuthRepository();
});

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return FakeAnnouncementRepository();
});
