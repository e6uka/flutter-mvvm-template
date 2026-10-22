import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_mvvm_template/theme/app_colors.dart';
import 'package:flutter_mvvm_template/view_models/home_view_model.dart';
import 'package:flutter_mvvm_template/widgets/cards/announcement_card.dart';
import 'package:flutter_mvvm_template/widgets/empty_state.dart';
import 'package:flutter_mvvm_template/widgets/error_state.dart';
import 'package:flutter_mvvm_template/widgets/loading_state.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final vm = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Hi, ${state.firstName}')),
      body: switch (state.status) {
        HomeStatus.loading => const LoadingState(label: 'Loading…'),
        HomeStatus.error => ErrorState(
          message: state.errorMessage!,
          onRetry: vm.refresh,
        ),
        HomeStatus.empty => EmptyState(
          icon: Icons.campaign_outlined,
          title: 'Nothing new',
          message: 'Announcements will show up here.',
          actionLabel: 'Refresh',
          onAction: vm.refresh,
        ),
        HomeStatus.ready => RefreshIndicator(
          color: AppColors.brand,
          onRefresh: vm.refresh,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.announcements.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) =>
                AnnouncementCard(announcement: state.announcements[i]),
          ),
        ),
      },
    );
  }
}
