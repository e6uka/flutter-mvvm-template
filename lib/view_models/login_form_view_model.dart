import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_mvvm_template/models/entities/login_credentials.dart';
import 'package:flutter_mvvm_template/store/auth_state_provider.dart';

@immutable
class LoginFormState {
  const LoginFormState({
    this.phone = '',
    this.password = '',
    this.showErrors = false,
    this.obscurePassword = true,
    this.isSubmitting = false,
    this.submitError,
  });

  final String phone;
  final String password;
  final bool showErrors;
  final bool obscurePassword;
  final bool isSubmitting;
  final String? submitError;

  static final _digits = RegExp(r'^\d{10,11}$');
  static const minPasswordLength = 6;

  String? get phoneError {
    if (!showErrors) return null;
    if (phone.isEmpty) return 'Enter your phone number.';
    if (!_digits.hasMatch(phone)) return 'Enter a 10 or 11 digit phone number.';
    return null;
  }

  String? get passwordError {
    if (!showErrors) return null;
    if (password.isEmpty) return 'Enter your password.';
    if (password.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters.';
    }
    return null;
  }

  bool get isValid =>
      _digits.hasMatch(phone) && password.length >= minPasswordLength;

  LoginFormState copyWith({
    String? phone,
    String? password,
    bool? showErrors,
    bool? obscurePassword,
    bool? isSubmitting,
    Object? submitError = _sentinel,
  }) => LoginFormState(
    phone: phone ?? this.phone,
    password: password ?? this.password,
    showErrors: showErrors ?? this.showErrors,
    obscurePassword: obscurePassword ?? this.obscurePassword,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    submitError: submitError == _sentinel
        ? this.submitError
        : submitError as String?,
  );

  static const _sentinel = Object();
}

class LoginFormViewModel extends AutoDisposeNotifier<LoginFormState> {
  @override
  LoginFormState build() {
    ref.listen(authStateProvider, (_, auth) {
      state = state.copyWith(
        isSubmitting: auth.isSubmitting,
        submitError: auth.errorMessage,
      );
    });
    final auth = ref.read(authStateProvider);
    return LoginFormState(
      isSubmitting: auth.isSubmitting,
      submitError: auth.errorMessage,
    );
  }

  void phoneChanged(String value) {
    state = state.copyWith(phone: value.trim());
    _clearSubmitError();
  }

  void passwordChanged(String value) {
    state = state.copyWith(password: value);
    _clearSubmitError();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  Future<void> submit() async {
    state = state.copyWith(showErrors: true);
    if (!state.isValid || state.isSubmitting) return;
    await ref
        .read(authStateProvider.notifier)
        .login(LoginCredentials(phone: state.phone, password: state.password));
  }

  void _clearSubmitError() {
    if (state.submitError != null) {
      ref.read(authStateProvider.notifier).clearError();
    }
  }
}

final loginFormViewModelProvider =
    NotifierProvider.autoDispose<LoginFormViewModel, LoginFormState>(
      LoginFormViewModel.new,
    );
