import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_mvvm_template/app.dart';
import 'package:flutter_mvvm_template/core/config/app_config.dart';
import 'package:flutter_mvvm_template/store/providers.dart';
import 'package:flutter_mvvm_template/theme/app_colors.dart';
import 'package:flutter_mvvm_template/theme/brand_palette.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await AppConfig.load();
  AppColors.install(BrandPalette.app);

  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const MainApp(),
    ),
  );
}
