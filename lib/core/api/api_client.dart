import 'package:dio/dio.dart';

import '../constants/app_config.dart';
import 'interceptors/auth_interceptor.dart';

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? Dio(_defaultOptions);

  static BaseOptions get _defaultOptions => BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      );

  final Dio _dio;

  Dio get client => _dio;

  void configure({String? token}) {
    _dio.interceptors.clear();
    _dio.interceptors.add(AuthInterceptor(token: token));
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}
