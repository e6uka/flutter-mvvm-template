import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_mvvm_template/models/entities/announcement.dart';
import 'package:flutter_mvvm_template/theme/app_colors.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key, required this.announcement});

  final Announcement announcement;

  static final _date = DateFormat('d MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(announcement.title, style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(announcement.body, style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              _date.format(announcement.publishedAt),
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
