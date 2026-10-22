import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_mvvm_template/models/entities/appearance.dart';
import 'package:flutter_mvvm_template/routing/app_router.dart';
import 'package:flutter_mvvm_template/store/appearance_controller.dart';
import 'package:flutter_mvvm_template/store/providers.dart';
import 'package:flutter_mvvm_template/theme/app_colors.dart';
import 'package:flutter_mvvm_template/theme/app_theme.dart';
import 'package:flutter_mvvm_template/theme/brand_palette.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final router = ref.watch(appRouterProvider);
    final brightness = switch (ref.watch(appearanceProvider)) {
      Appearance.light => Brightness.light,
      Appearance.dark => Brightness.dark,
      Appearance.system => MediaQuery.platformBrightnessOf(context),
    };
    const palette = BrandPalette.app;
    AppColors.install(palette, brightness: brightness);

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      theme: brightness == Brightness.dark
          ? AppTheme.dark(palette.brand)
          : AppTheme.light(palette.brand),
      routerConfig: router,
      builder: (context, child) => KeyedSubtree(
        key: ValueKey(brightness),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
