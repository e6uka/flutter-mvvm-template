import 'package:flutter_mvvm_template/models/entities/announcement.dart';
import 'package:flutter_mvvm_template/repositories/announcement_repository.dart';

class FakeAnnouncementRepository implements AnnouncementRepository {
  FakeAnnouncementRepository({
    this.latency = const Duration(milliseconds: 700),
  });

  final Duration latency;

  @override
  Future<List<Announcement>> fetchLatest() async {
    await Future<void>.delayed(latency);
    return [
      Announcement(
        id: 'a-1',
        title: 'Welcome aboard',
        body:
            'This list comes from FakeAnnouncementRepository. Swap it for '
            'a real repository in store/providers.dart when the API is ready.',
        publishedAt: DateTime(2026, 10, 20),
      ),
      Announcement(
        id: 'a-2',
        title: 'Pull to refresh',
        body: 'Every data screen ships with loading, empty and error states.',
        publishedAt: DateTime(2026, 10, 18),
      ),
    ];
  }
}
