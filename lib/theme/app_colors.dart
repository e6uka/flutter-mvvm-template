import 'package:flutter/material.dart';

import 'package:flutter_mvvm_template/theme/brand_palette.dart';

class AppColors {
  AppColors._();

  static BrandPalette? _palette;
  static Brightness _brightness = Brightness.light;

  static void install(
    BrandPalette palette, {
    Brightness brightness = Brightness.light,
  }) {
    _palette = palette;
    _brightness = brightness;
  }

  static BrandPalette get _p {
    final p = _palette;
    if (p == null) {
      throw StateError(
        'AppColors used before AppColors.install() — call from bootstrap.',
      );
    }
    return p;
  }

  static bool get isDark => _brightness == Brightness.dark;

  static Color get brand => _p.brand;
  static Color get brandSoftText => _p.brandSoftText;
  static Color get textAccent => _p.textAccent;

  static Color get brandSoft => isDark
      ? Color.alphaBlend(_p.brand.withValues(alpha: 0.28), card)
      : _p.brandSoft;
  static Color get brandLighter => isDark
      ? Color.alphaBlend(_p.brand.withValues(alpha: 0.16), card)
      : _p.brandLighter;

  static Color get screen =>
      isDark ? const Color(0xFF17181C) : const Color(0xFFF7F7F7);
  static Color get card =>
      isDark ? const Color(0xFF25272D) : const Color(0xFFFFFFFF);
  static Color get inputAreaSoft =>
      isDark ? const Color(0xFF31333B) : const Color(0xFFF3F5F8);

  static Color get textStrong =>
      isDark ? const Color(0xFFF1F2F4) : const Color(0xFF101828);
  static Color get textLabel =>
      isDark ? const Color(0xFFCED2DA) : const Color(0xFF344054);
  static Color get textBody =>
      isDark ? const Color(0xFFADB2BD) : const Color(0xFF475467);
  static Color get textMuted =>
      isDark ? const Color(0xFF888D98) : const Color(0xFF667085);

  static Color get border =>
      isDark ? const Color(0xFF3C3E46) : const Color(0xFFD0D5DD);
  static Color get shadowXs =>
      isDark ? const Color(0x40000000) : const Color(0x0D101828);

  static Color get success => const Color(0xFF067647);
  static Color get danger => const Color(0xFFB42318);
}
