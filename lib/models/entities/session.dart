import 'package:equatable/equatable.dart';

import 'package:flutter_mvvm_template/models/entities/user.dart';

class Session extends Equatable {
  const Session({required this.token, required this.user});

  final String token;
  final User user;

  @override
  List<Object?> get props => [token, user];
}
