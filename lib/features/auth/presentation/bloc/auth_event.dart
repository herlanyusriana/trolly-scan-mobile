import 'package:equatable/equatable.dart';

import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested(this.request);

  final LoginRequest request;

  @override
  List<Object?> get props => [request];
}

class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested(this.request);

  final RegisterRequest request;

  @override
  List<Object?> get props => [request];
}

class AuthCheckStatus extends AuthEvent {
  const AuthCheckStatus();
}

class AuthLogout extends AuthEvent {
  const AuthLogout();
}

class AuthSessionChecked extends AuthEvent {
  const AuthSessionChecked();
}
