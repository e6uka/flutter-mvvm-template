import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_mvvm_template/core/errors/app_exception.dart';
import 'package:flutter_mvvm_template/models/entities/announcement.dart';
import 'package:flutter_mvvm_template/store/providers.dart';
import 'package:flutter_mvvm_template/store/session_provider.dart';

enum HomeStatus { loading, empty, error, ready }

@immutable
class HomeState {
  const HomeState({
    required this.firstName,
    this.isLoading = true,
    this.errorMessage,
    this.announcements = const [],
  });

  final String firstName;
  final bool isLoading;
  final String? errorMessage;
  final List<Announcement> announcements;

  HomeStatus get status {
    if (isLoading) return HomeStatus.loading;
    if (errorMessage != null) return HomeStatus.error;
    if (announcements.isEmpty) return HomeStatus.empty;
    return HomeStatus.ready;
  }

  HomeState copyWith({
    bool? isLoading,
    Object? errorMessage = _sentinel,
    List<Announcement>? announcements,
  }) => HomeState(
    firstName: firstName,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage == _sentinel
        ? this.errorMessage
        : errorMessage as String?,
    announcements: announcements ?? this.announcements,
  );

  static const _sentinel = Object();
}

class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    final user = ref.watch(sessionProvider.select((s) => s?.user));
    unawaited(Future.microtask(refresh));
    return HomeState(firstName: user?.firstName ?? '');
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final items = await ref
          .read(announcementRepositoryProvider)
          .fetchLatest();
      state = state.copyWith(isLoading: false, announcements: items);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Couldn’t load announcements. Try again.',
      );
    }
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(
  HomeViewModel.new,
);
