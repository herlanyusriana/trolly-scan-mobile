import 'package:fpdart/fpdart.dart';

import '../entities/mobile_user.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../data/models/reset_password_request.dart';

abstract class AuthRepository {
  Future<Either<String, MobileUser>> login(LoginRequest request);
  Future<Either<String, String>> register(RegisterRequest request);
  Future<Either<String, String>> resetPassword(ResetPasswordRequest request);
  MobileUser? readSavedUser();
  Future<void> clearSession();
}
