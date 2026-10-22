import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_mvvm_template/models/entities/session.dart';

class SessionController extends Notifier<Session?> {
  @override
  Session? build() => null;

  void set(Session session) => state = session;
  void clear() => state = null;
}

final sessionProvider = NotifierProvider<SessionController, Session?>(
  SessionController.new,
);
