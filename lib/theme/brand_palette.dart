import 'package:flutter/material.dart';

class BrandPalette {
  const BrandPalette({
    required this.brand,
    required this.brandSoft,
    required this.brandLighter,
    required this.brandSoftText,
    required this.textAccent,
  });

  final Color brand;
  final Color brandSoft;
  final Color brandLighter;
  final Color brandSoftText;
  final Color textAccent;

  static const app = BrandPalette(
    brand: Color(0xFF4F46E5),
    brandSoft: Color(0xFFE0E7FF),
    brandLighter: Color(0xFFF5F7FF),
    brandSoftText: Color(0xFF7C80B8),
    textAccent: Color(0xFF3730A3),
  );
}
