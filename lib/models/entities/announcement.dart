import 'package:equatable/equatable.dart';

class Announcement extends Equatable {
  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final String body;
  final DateTime publishedAt;

  @override
  List<Object?> get props => [id, title, body, publishedAt];
}
