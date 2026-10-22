import 'package:flutter_mvvm_template/models/entities/announcement.dart';

abstract class AnnouncementRepository {
  Future<List<Announcement>> fetchLatest();
}
