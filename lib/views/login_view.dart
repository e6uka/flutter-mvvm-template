import 'package:flutter/material.dart';

import 'package:flutter_mvvm_template/constants/app_brand.dart';
import 'package:flutter_mvvm_template/theme/app_colors.dart';
import 'package:flutter_mvvm_template/widgets/brand_logo.dart';
import 'package:flutter_mvvm_template/widgets/forms/login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.card,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandLogo(size: 36),
                  const SizedBox(height: 40),
                  Text('Sign in', style: textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(AppBrand.tagline, style: textTheme.bodyMedium),
                  const SizedBox(height: 28),
                  const LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
