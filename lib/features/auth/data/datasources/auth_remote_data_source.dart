import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final ApiClient _client;

  void configureToken(String? token) {
    _client.configure(token: token);
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _client.client.post<Map<String, dynamic>>(
        '/api/v1/auth/login',
        data: request.toJson(),
      );

      return LoginResponse.fromJson(response.data!);
    } on DioException catch (error) {
      throw DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        message: error.response?.data['message']?.toString() ?? 'Login failed',
      );
    }
  }

  Future<void> register(RegisterRequest request) async {
    try {
      final payload = request.toJson();
      payload['password_confirmation'] = request.passwordConfirmation;
      payload.remove('passwordConfirmation');

      if ((payload['phone'] as String?)?.isEmpty ?? true) {
        payload.remove('phone');
      }

      if ((payload['email'] as String?)?.isEmpty ?? true) {
        payload.remove('email');
      }

      await _client.client.post('/api/v1/auth/register', data: payload);
    } on DioException catch (error) {
      throw DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        message:
            error.response?.data['message']?.toString() ?? 'Registrasi gagal',
      );
    }
  }
}
