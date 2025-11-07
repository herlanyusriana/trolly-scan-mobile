import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/mobile_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<String, MobileUser>> login(LoginRequest request) async {
    try {
      final response = await _remoteDataSource.login(request);
      _remoteDataSource.configureToken(response.token);
      return right(response.user.copyWith(token: response.token));
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
      return right('Registrasi berhasil. Menunggu persetujuan admin.');
    } on DioException catch (error) {
      final message = error.message ?? 'Registrasi gagal.';
      return left(message);
    } catch (error) {
      return left(error.toString());
    }
  }
}
