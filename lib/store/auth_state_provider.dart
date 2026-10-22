import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_mvvm_template/core/errors/app_exception.dart';
import 'package:flutter_mvvm_template/models/entities/login_credentials.dart';
import 'package:flutter_mvvm_template/store/providers.dart';
import 'package:flutter_mvvm_template/store/session_provider.dart';

@immutable
class AuthState {
  const AuthState({
    required this.isInitializing,
    required this.isAuthenticated,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final bool isInitializing;
  final bool isAuthenticated;
  final bool isSubmitting;
  final String? errorMessage;

  AuthState copyWith({
    bool? isInitializing,
    bool? isAuthenticated,
    bool? isSubmitting,
    Object? errorMessage = _sentinel,
  }) => AuthState(
    isInitializing: isInitializing ?? this.isInitializing,
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    errorMessage: errorMessage == _sentinel
        ? this.errorMessage
        : errorMessage as String?,
  );

  static const _sentinel = Object();
}

class AuthStateController extends Notifier<AuthState> {
  static const splashHold = Duration(milliseconds: 1200);

  @override
  AuthState build() {
    final timer = Timer(splashHold, () {
      if (state.isInitializing) {
        state = state.copyWith(isInitializing: false);
      }
    });
    ref.onDispose(timer.cancel);
    return const AuthState(isInitializing: true, isAuthenticated: false);
  }

  Future<void> login(LoginCredentials credentials) async {
    if (state.isSubmitting) return;
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final session = await ref.read(authRepositoryProvider).login(credentials);
      ref.read(sessionProvider.notifier).set(session);
      state = const AuthState(isInitializing: false, isAuthenticated: true);
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.message);
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('AuthStateController.login: ${e.runtimeType}: $e');
        debugPrintStack(stackTrace: stack);
      }
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).logout();
    ref.read(sessionProvider.notifier).clear();
    state = const AuthState(isInitializing: false, isAuthenticated: false);
  }
}

final authStateProvider = NotifierProvider<AuthStateController, AuthState>(
  AuthStateController.new,
);
