import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mvvm_template/core/errors/app_exception.dart';
import 'package:flutter_mvvm_template/models/entities/announcement.dart';
import 'package:flutter_mvvm_template/repositories/announcement_repository.dart';
import 'package:flutter_mvvm_template/view_models/home_view_model.dart';

import '../helpers.dart';

class _StubAnnouncements implements AnnouncementRepository {
  _StubAnnouncements({this.error});

  final Object? error;

  @override
  Future<List<Announcement>> fetchLatest() async {
    if (error != null) throw error!;
    return const [];
  }
}

void main() {
  test('loads announcements on start', () async {
    final container = makeContainer();
    addTearDown(container.dispose);

    expect(container.read(homeViewModelProvider).status, HomeStatus.loading);
    await container.read(homeViewModelProvider.notifier).refresh();

    expect(container.read(homeViewModelProvider).status, HomeStatus.ready);
  });

  test('no announcements shows the empty state', () async {
    final container = makeContainer(announcements: _StubAnnouncements());
    addTearDown(container.dispose);

    await container.read(homeViewModelProvider.notifier).refresh();

    expect(container.read(homeViewModelProvider).status, HomeStatus.empty);
  });

  test('a failed load shows the error state', () async {
    final container = makeContainer(
      announcements: _StubAnnouncements(error: const AppException('Down.')),
    );
    addTearDown(container.dispose);

    await container.read(homeViewModelProvider.notifier).refresh();

    final state = container.read(homeViewModelProvider);
    expect(state.status, HomeStatus.error);
    expect(state.errorMessage, 'Down.');
  });
}
