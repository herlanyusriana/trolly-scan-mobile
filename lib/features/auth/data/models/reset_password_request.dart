class ResetPasswordRequest {
  const ResetPasswordRequest({
    required this.identity,
    required this.password,
    required this.passwordConfirmation,
  });

  final String identity;
  final String password;
  final String passwordConfirmation;

  Map<String, dynamic> toJson() => {
    'identity': identity,
    'password': password,
    'password_confirmation': passwordConfirmation,
  };
}
