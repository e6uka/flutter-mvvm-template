import 'package:flutter_mvvm_template/core/errors/app_exception.dart';
import 'package:flutter_mvvm_template/models/entities/login_credentials.dart';
import 'package:flutter_mvvm_template/models/entities/user.dart';
import 'package:flutter_mvvm_template/models/entities/session.dart';
import 'package:flutter_mvvm_template/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.latency = const Duration(milliseconds: 800)});

  final Duration latency;

  static const rejectedPhonePrefix = '000';

  @override
  Future<Session> login(LoginCredentials credentials) async {
    await Future<void>.delayed(latency);
    if (credentials.phone.startsWith(rejectedPhonePrefix)) {
      throw const AppException('Incorrect phone number or password.');
    }
    return Session(
      token: 'fake-token',
      user: User(
        id: 'user-1',
        firstName: 'Ada',
        lastName: 'Lovelace',
        phone: credentials.phone,
      ),
    );
  }

  @override
  Future<void> logout() => Future<void>.delayed(latency ~/ 4);
}
