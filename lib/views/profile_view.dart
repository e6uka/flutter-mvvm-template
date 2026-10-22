import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_mvvm_template/models/entities/appearance.dart';
import 'package:flutter_mvvm_template/theme/app_colors.dart';
import 'package:flutter_mvvm_template/view_models/profile_view_model.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    final vm = ref.read(profileViewModelProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.brandSoft,
                child: Text(
                  state.initials,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brand,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.fullName, style: textTheme.titleMedium),
                    Text(state.phone, style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text('Appearance', style: textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<Appearance>(
            showSelectedIcon: false,
            segments: [
              for (final option in Appearance.values)
                ButtonSegment(value: option, label: Text(option.label)),
            ],
            selected: {state.appearance},
            onSelectionChanged: (selection) =>
                vm.setAppearance(selection.first),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: state.isSigningOut ? null : vm.signOut,
            icon: state.isSigningOut
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
