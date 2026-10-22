import 'package:equatable/equatable.dart';

class LoginCredentials extends Equatable {
  const LoginCredentials({required this.phone, required this.password});

  final String phone;
  final String password;

  @override
  List<Object?> get props => [phone, password];
}
