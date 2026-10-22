import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mvvm_template/store/auth_state_provider.dart';
import 'package:flutter_mvvm_template/store/session_provider.dart';
import 'package:flutter_mvvm_template/view_models/login_form_view_model.dart';

import '../helpers.dart';

void main() {
  test('hides errors until the first submit', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    container.listen(loginFormViewModelProvider, (_, _) {});

    final state = container.read(loginFormViewModelProvider);
    expect(state.phoneError, isNull);
    expect(state.passwordError, isNull);
  });

  test(
    'submit with empty fields shows both errors and does not log in',
    () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      container.listen(loginFormViewModelProvider, (_, _) {});

      await container.read(loginFormViewModelProvider.notifier).submit();

      final state = container.read(loginFormViewModelProvider);
      expect(state.phoneError, 'Enter your phone number.');
      expect(state.passwordError, 'Enter your password.');
      expect(container.read(authStateProvider).isAuthenticated, isFalse);
    },
  );

  test('valid credentials sign the user in', () async {
    final container = makeContainer();
    addTearDown(container.dispose);
    container.listen(loginFormViewModelProvider, (_, _) {});
    final vm = container.read(loginFormViewModelProvider.notifier);

    vm.phoneChanged('08012345678');
    vm.passwordChanged('secret1');
    await vm.submit();

    expect(container.read(authStateProvider).isAuthenticated, isTrue);
    expect(container.read(sessionProvider)?.user.phone, '08012345678');
  });

  test('rejected credentials surface the error and clear on edit', () async {
    final container = makeContainer();
    addTearDown(container.dispose);
    container.listen(loginFormViewModelProvider, (_, _) {});
    final vm = container.read(loginFormViewModelProvider.notifier);

    vm.phoneChanged('00012345678');
    vm.passwordChanged('secret1');
    await vm.submit();

    expect(
      container.read(loginFormViewModelProvider).submitError,
      'Incorrect phone number or password.',
    );

    vm.passwordChanged('secret12');
    expect(container.read(loginFormViewModelProvider).submitError, isNull);
  });
}
