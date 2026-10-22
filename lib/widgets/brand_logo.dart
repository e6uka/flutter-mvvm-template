import 'package:flutter/material.dart';

import 'package:flutter_mvvm_template/constants/app_brand.dart';
import 'package:flutter_mvvm_template/theme/app_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.brand,
            borderRadius: BorderRadius.circular(size * 0.28),
          ),
          child: Icon(AppBrand.icon, color: Colors.white, size: size * 0.62),
        ),
        SizedBox(width: size * 0.28),
        Text(
          AppBrand.name,
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppColors.textStrong,
          ),
        ),
      ],
    );
  }
}
