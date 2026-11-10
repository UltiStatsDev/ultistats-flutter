/// Ошибка аутентификации или авторизации.
///
/// [code] — машиночитаемый код из ProblemDetail (`AUTH_CREDENTIALS_INVALID`,
/// `CSRF_INVALID` и т.д.). Для сетевых ошибок код — `NETWORK`.
class AuthException implements Exception {
  const AuthException({
    required this.message,
    this.statusCode,
    this.code,
    this.retryAfter,
  });

  final String message;
  final int? statusCode;
  final String? code;
  final Duration? retryAfter;

  bool get isSessionInvalid => statusCode == 401;

  bool get isRateLimited => statusCode == 429;

  bool get isPermissionDenied =>
      statusCode == 403 && code == 'AUTH_PERMISSION_DENIED';

  @override
  String toString() => 'AuthException(${code ?? statusCode}): $message';
}
