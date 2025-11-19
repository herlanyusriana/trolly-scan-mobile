import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthState()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthLogout>(_onLogout);
    on<AuthSessionChecked>(_onSessionChecked);
  }

  final AuthRepository _repository;

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null, info: null));

    final result = await _repository.login(event.request);

    result.match(
      (error) => emit(state.copyWith(status: AuthStatus.failure, error: error)),
      (user) {
        if (user.status == 'pending') {
          emit(state.copyWith(status: AuthStatus.pendingApproval, user: user));
        } else {
          emit(state.copyWith(status: AuthStatus.success, user: user));
        }
      },
    );
  }

  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null, info: null));

    final result = await _repository.register(event.request);

    result.match(
      (error) => emit(state.copyWith(status: AuthStatus.failure, error: error)),
      (message) =>
          emit(state.copyWith(status: AuthStatus.registered, info: message)),
    );
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    await _repository.clearSession();
    emit(const AuthState(status: AuthStatus.initial));
  }

  Future<void> _onSessionChecked(
    AuthSessionChecked event,
    Emitter<AuthState> emit,
  ) async {
    final savedUser = _repository.readSavedUser();
    if (savedUser != null) {
      emit(state.copyWith(status: AuthStatus.success, user: savedUser));
    } else {
      emit(const AuthState(status: AuthStatus.initial));
    }
  }
}

extension AuthBlocX on AuthBloc {
  void login({required String identity, required String password}) {
    add(
      AuthLoginRequested(LoginRequest(identity: identity, password: password)),
    );
  }

  void logout() {
    add(const AuthLogout());
  }

  void checkSession() {
    add(const AuthSessionChecked());
  }

  void register({
    required String name,
    String? phone,
    String? email,
    required String password,
    required String confirmPassword,
  }) {
    add(
      AuthRegisterRequested(
        RegisterRequest(
          name: name,
          phone: (phone?.isEmpty ?? true) ? null : phone,
          email: (email?.isEmpty ?? true) ? null : email,
          password: password,
          passwordConfirmation: confirmPassword,
        ),
      ),
    );
  }
}
