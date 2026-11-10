import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ultistats/features/auth/domain/entities/auth_exception.dart';

AuthException mapAuthException(DioException error) {
  final response = error.response;
  if (response == null) {
    return const AuthException(
      code: 'NETWORK',
      message:
          'Нет связи с сервером. Проверьте подключение и попробуйте снова.',
    );
  }

  final code = _problemCode(response.data);
  return AuthException(
    statusCode: response.statusCode,
    code: code,
    message: _messageFor(code, response.statusCode),
    retryAfter: _retryAfter(response.headers.value('retry-after')),
  );
}

String? _problemCode(Object? data) {
  final body = switch (data) {
    final Map<String, dynamic> map => map,
    final String text => _tryDecode(text),
    _ => null,
  };
  final code = body?['code'];
  return code is String && code.isNotEmpty ? code : null;
}

Map<String, dynamic>? _tryDecode(String text) {
  try {
    final decoded = jsonDecode(text);
    return decoded is Map<String, dynamic> ? decoded : null;
  } on FormatException {
    return null;
  }
}

String _messageFor(String? code, int? status) {
  return switch (code) {
    'AUTH_CREDENTIALS_INVALID' => 'Неверный логин или пароль',
    'AUTH_RATE_LIMITED' =>
      'Слишком много попыток. Подождите немного и попробуйте снова.',
    'AUTH_REQUIRED' ||
    'AUTH_SESSION_INVALID' ||
    'AUTH_SESSION_EXPIRED' ||
    'AUTH_SESSION_REVOKED' => 'Сессия истекла. Войдите снова.',
    'AUTH_CONTEXT_REQUIRED' ||
    'AUTH_IDENTITY_MISMATCH' => 'Сессия устарела. Войдите снова.',
    'AUTH_PERMISSION_DENIED' => 'Недостаточно прав для этого действия',
    'AUTH_PASSWORD_CHANGE_REQUIRED' => 'Сначала смените пароль',
    'AUTH_ACCOUNT_BLOCKED' => 'Учётная запись заблокирована',
    'AUTH_REAUTH_REQUIRED' => 'Подтвердите пароль, чтобы продолжить',
    'CSRF_INVALID' => 'Не удалось проверить безопасность запроса',
    'PUBLIC_TRANSPORT_READ_ONLY' => 'Сервер доступен только для просмотра',
    'NETWORK' =>
      'Нет связи с сервером. Проверьте подключение и попробуйте снова.',
    _ => switch (status ?? 0) {
      400 => 'Проверьте введённые данные',
      401 => 'Требуется вход',
      403 => 'Действие недоступно',
      404 => 'Не найдено',
      429 => 'Слишком много запросов. Попробуйте позже.',
      >= 500 => 'Ошибка на сервере. Попробуйте позже.',
      _ => 'Не удалось выполнить запрос',
    },
  };
}

Duration? _retryAfter(String? header) {
  if (header == null) return null;
  final seconds = int.tryParse(header.trim());
  return seconds == null ? null : Duration(seconds: seconds);
}
