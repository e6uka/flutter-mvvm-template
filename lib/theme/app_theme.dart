import 'package:flutter/material.dart';

import 'package:flutter_mvvm_template/theme/app_colors.dart';

class AppTheme {
  static ThemeData light(Color brandSeed) {
    return _base(
      ColorScheme.fromSeed(
        seedColor: brandSeed,
        brightness: Brightness.light,
        primary: brandSeed,
        surface: AppColors.card,
      ),
    );
  }

  static ThemeData dark(Color brandSeed) {
    return _base(
      ColorScheme.fromSeed(
        seedColor: brandSeed,
        brightness: Brightness.dark,
        surface: AppColors.card,
      ),
    );
  }

  static ThemeData _base(ColorScheme scheme) {
    final labelStyle = TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textLabel,
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.border),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.screen,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.card,
        foregroundColor: scheme.onSurface,
        elevation: 2,
        scrolledUnderElevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.16),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        iconTheme: IconThemeData(size: 20, color: AppColors.brand),
        actionsIconTheme: IconThemeData(size: 20, color: AppColors.brand),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.card,
        indicatorColor: AppColors.brandSoft,
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.brand
                : AppColors.textMuted,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brand,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.brandSoft,
          disabledForegroundColor: AppColors.brand.withValues(alpha: 0.5),
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 24 / 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brand,
          side: BorderSide(color: AppColors.border),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brand,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        labelStyle: labelStyle,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: TextStyle(
          fontSize: 16,
          height: 24 / 16,
          color: AppColors.textMuted,
        ),
        helperStyle: const TextStyle(fontSize: 12, height: 16 / 12),
        errorStyle: const TextStyle(fontSize: 12, height: 16 / 12),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.brand),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 28 / 20,
          color: AppColors.textStrong,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          height: 28 / 22,
          color: AppColors.textStrong,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 24 / 16,
          color: AppColors.textStrong,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 22 / 14,
          color: AppColors.textBody,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          height: 18 / 12,
          color: AppColors.textMuted,
        ),
        labelLarge: labelStyle,
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 24 / 16,
          color: AppColors.textStrong,
        ),
      ),
    );
  }
}
