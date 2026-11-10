import 'package:dio/dio.dart';
import 'package:ultistats/features/auth/data/auth_credentials.dart';
import 'package:ultistats/features/auth/data/models/csrf_token_model.dart';

/// Подставляет в запросы installation/account/session и CSRF-токен.
///
/// Правила взяты из контракта auth-v1:
/// * `GET /auth/csrf` и бутстрап `GET /auth/session` идут без identity-заголовков;
/// * `POST /auth/login` требует только installation id;
/// * остальные запросы получают все три заголовка, если есть сессия;
/// * каждый небезопасный метод требует CSRF-токен.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.dio, required this.credentials});

  static const _skipAuthKey = 'auth.skip';
  static const _retriedKey = 'auth.retried';

  static const _installationHeader = 'X-UltiStats-Installation-Id';
  static const _accountHeader = 'X-UltiStats-Account-Id';
  static const _sessionHeader = 'X-UltiStats-Session-Id';
  static const defaultCsrfHeader = 'X-CSRF-TOKEN';

  final Dio dio;
  final AuthCredentials credentials;

  Future<void>? _csrfFetch;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[_skipAuthKey] == true) {
      handler.next(options);
      return;
    }

    _attachIdentity(options);

    if (_isUnsafe(options.method)) {
      try {
        await _ensureCsrf();
      } catch (error, stackTrace) {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.unknown,
            error: error,
            stackTrace: stackTrace,
          ),
          true,
        );
        return;
      }

      final token = credentials.csrfToken;
      if (token != null) {
        options.headers[credentials.csrfHeaderName ?? defaultCsrfHeader] =
            token;
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final code = _problemCode(response?.data);

    // Сервер мог провернуть CSRF-токен (например, сразу после логина).
    // Один раз обновляем токен и повторяем запрос.
    if (response?.statusCode == 403 &&
        code == 'CSRF_INVALID' &&
        err.requestOptions.extra[_retriedKey] != true) {
      credentials.clearCsrf();
      try {
        await _ensureCsrf();
        final retried = await _retry(err.requestOptions);
        handler.resolve(retried);
      } catch (retryError, stackTrace) {
        handler.next(
          retryError is DioException
              ? retryError
              : DioException(
                  requestOptions: err.requestOptions,
                  type: DioExceptionType.unknown,
                  error: retryError,
                  stackTrace: stackTrace,
                ),
        );
      }
      return;
    }

    if (response?.statusCode == 401 && credentials.hasSession) {
      _expireSession();
    } else if (response?.statusCode == 403 &&
        code == 'AUTH_PASSWORD_CHANGE_REQUIRED') {
      credentials.onPasswordChangeRequired?.call();
    }

    handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions request) async {
    request.extra[_retriedKey] = true;
    final token = credentials.csrfToken;
    if (token != null) {
      request.headers[credentials.csrfHeaderName ?? defaultCsrfHeader] = token;
    }
    return dio.fetch<dynamic>(request);
  }

  void _attachIdentity(RequestOptions options) {
    final path = options.uri.path;
    final isCsrf = path.endsWith('/auth/csrf');
    final isLogin = path.endsWith('/auth/login');
    final isBootstrap =
        path.endsWith('/auth/session') && !credentials.hasSession;

    if (isCsrf || isBootstrap) return;

    final installationId = credentials.installationId;
    if (installationId != null) {
      options.headers[_installationHeader] = installationId;
    }

    if (!isLogin && credentials.hasSession) {
      options.headers[_accountHeader] = credentials.accountId;
      options.headers[_sessionHeader] = credentials.sessionId;
    }
  }

  Future<void> _ensureCsrf() {
    if (credentials.csrfToken != null) return Future.value();
    return _csrfFetch ??= _fetchCsrf();
  }

  Future<void> _fetchCsrf() async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/auth/csrf',
        options: Options(extra: {_skipAuthKey: true}),
      );
      final data = response.data;
      if (data == null) throw StateError('Empty CSRF response');
      final token = CsrfTokenModel.fromJson(data);
      credentials.csrfHeaderName = token.headerName;
      credentials.csrfToken = token.token;
    } finally {
      _csrfFetch = null;
    }
  }

  void _expireSession() {
    credentials.clearSession();
    credentials.onSessionExpired?.call();
  }

  static bool _isUnsafe(String method) =>
      method != 'GET' && method != 'HEAD' && method != 'OPTIONS';

  static String? _problemCode(Object? data) {
    if (data is Map && data['code'] is String) return data['code'] as String;
    return null;
  }
}
