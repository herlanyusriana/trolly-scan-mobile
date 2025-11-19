import 'package:equatable/equatable.dart';

import '../../domain/entities/mobile_user.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  pendingApproval,
  registered,
  failure,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.info,
  });

  final AuthStatus status;
  final MobileUser? user;
  final String? error;
  final String? info;

  AuthState copyWith({
    AuthStatus? status,
    MobileUser? user,
    String? error,
    String? info,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      info: info ?? this.info,
    );
  }

  @override
  List<Object?> get props => [status, user, error, info];
}
