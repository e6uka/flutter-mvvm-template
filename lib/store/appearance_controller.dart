import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_mvvm_template/models/entities/appearance.dart';

class AppearanceController extends Notifier<Appearance> {
  static const _key = 'theme.mode';

  @override
  Appearance build() {
    Future.microtask(_load);
    return Appearance.light;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = Appearance.parse(prefs.getString(_key));
  }

  Future<void> set(Appearance appearance) async {
    state = appearance;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, appearance.name);
  }
}

final appearanceProvider = NotifierProvider<AppearanceController, Appearance>(
  AppearanceController.new,
);
