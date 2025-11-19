import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/storage/session_storage.dart';
import '../../domain/entities/mobile_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._sessionStorage);

  final AuthRemoteDataSource _remoteDataSource;
  final SessionStorage _sessionStorage;

  @override
  Future<Either<String, MobileUser>> login(LoginRequest request) async {
    try {
      final response = await _remoteDataSource.login(request);
      final user = response.user.copyWith(token: response.token);
      _remoteDataSource.configureToken(response.token);
      await _sessionStorage.saveUser(user);
      return right(user);
    } on DioException catch (error) {
      final message = error.message ?? 'Login gagal.';
      return left(message);
    } catch (error) {
      return left(error.toString());
    }
  }

  @override
  Future<Either<String, String>> register(RegisterRequest request) async {
    try {
      await _remoteDataSource.register(request);
      _remoteDataSource.configureToken(null);
      await _sessionStorage.clearUser();
      return right('Registrasi berhasil. Menunggu persetujuan admin.');
    } on DioException catch (error) {
      final message = error.message ?? 'Registrasi gagal.';
      return left(message);
    } catch (error) {
      return left(error.toString());
    }
  }

  @override
  MobileUser? readSavedUser() {
    final user = _sessionStorage.readUser();
    if (user?.token != null) {
      _remoteDataSource.configureToken(user!.token);
    }
    return user;
  }

  @override
  Future<void> clearSession() async {
    await _sessionStorage.clearUser();
    _remoteDataSource.configureToken(null);
  }
}
