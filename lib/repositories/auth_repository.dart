import 'package:flutter_mvvm_template/models/entities/login_credentials.dart';
import 'package:flutter_mvvm_template/models/entities/session.dart';

abstract class AuthRepository {
  Future<Session> login(LoginCredentials credentials);

  Future<void> logout();
}
