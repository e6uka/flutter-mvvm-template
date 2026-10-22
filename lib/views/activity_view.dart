import 'package:flutter/material.dart';

import 'package:flutter_mvvm_template/widgets/empty_state.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: const EmptyState(
        icon: Icons.history_rounded,
        title: 'No activity yet',
        message: 'Things you do in the app will show here.',
      ),
    );
  }
}
