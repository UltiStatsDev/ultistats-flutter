import 'package:dio/dio.dart';
import 'package:ultistats/core/logging/app_logger.dart';
import 'package:ultistats/core/network/cookie_store.dart';
import 'package:ultistats/features/auth/data/auth_credentials.dart';
import 'package:ultistats/features/auth/data/auth_error_mapper.dart';
import 'package:ultistats/features/auth/data/models/auth_context_model.dart';
import 'package:ultistats/features/auth/data/requests/change_password_request.dart';
import 'package:ultistats/features/auth/data/requests/expected_session_request.dart';
import 'package:ultistats/features/auth/data/requests/login_request.dart';
import 'package:ultistats/features/auth/data/sources/auth_api.dart';
import 'package:ultistats/features/auth/domain/entities/auth_exception.dart';
import 'package:ultistats/features/auth/domain/entities/auth_session.dart';
import 'package:ultistats/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthApi api,
    required AuthCredentials credentials,
    required CookieStore cookies,
  }) : _api = api,
       _credentials = credentials,
       _cookies = cookies;

  final AuthApi _api;
  final AuthCredentials _credentials;
  final CookieStore _cookies;

  @override
  Future<AuthSession> restore() async {
    try {
      final installation = await _guard(_api.getInstallation);
      _credentials.installationId = installation.installationId;

      final context = await _guard(_api.getSession);
      _apply(context);
      return context.toEntity();
    } on AuthException catch (error) {
      if (!error.isSessionInvalid) rethrow;

      // Cookie осталась от протухшей сессии: без её удаления каждый следующий
      // запрос снова получал бы 401.
      log(
        'Stored session is no longer valid, clearing it',
        name: runtimeType.toString(),
        level: AppLogLevel.warning,
      );
      await _cookies.clear();
      _credentials.clearSession();
      return AuthSession.anonymous(installationId: _credentials.installationId);
    }
  }

  @override
  Future<AuthSession> login({
    required String login,
    required String password,
  }) async {
    await _ensureInstallation();

    final context = await _guard(
      () => _api.login(LoginRequest(login: login, password: password)),
    );
    _apply(context);

    // Сервер сбрасывает CSRF-токен при логине: следующий получим заново.
    _credentials.clearCsrf();

    return context.toEntity();
  }

  @override
  Future<AuthSession> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final context = await _guard(
      () => _api.changePassword(
        ChangePasswordRequest(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ),
    );
    _apply(context);
    _credentials.clearCsrf();
    return context.toEntity();
  }

  @override
  Future<AuthSession> renew() async {
    final sessionId = _credentials.sessionId;
    if (sessionId == null) {
      throw const AuthException(
        code: 'AUTH_REQUIRED',
        message: 'Сессия истекла. Войдите снова.',
      );
    }

    final context = await _guard(
      () => _api.renew(ExpectedSessionRequest(expectedSessionId: sessionId)),
    );
    _apply(context);
    return context.toEntity();
  }

  @override
  Future<void> logout() async {
    final sessionId = _credentials.sessionId;
    try {
      if (sessionId != null) {
        await _guard(
          () =>
              _api.logout(ExpectedSessionRequest(expectedSessionId: sessionId)),
        );
      }
    } on AuthException catch (error) {
      // Выход должен работать и без сети: локальную cookie всё равно удаляем.
      log(
        'Logout request failed, clearing local session anyway',
        error: error,
        name: runtimeType.toString(),
        level: AppLogLevel.warning,
      );
    } finally {
      await _cookies.clear();
      _credentials.clearSession();
    }
  }

  Future<void> _ensureInstallation() async {
    if (_credentials.installationId != null) return;
    final installation = await _guard(_api.getInstallation);
    _credentials.installationId = installation.installationId;
  }

  void _apply(AuthContextModel context) {
    _credentials
      ..installationId = context.installationId
      ..accountId = context.account?.id
      ..sessionId = context.sessionId;
  }

  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      throw mapAuthException(error);
    }
  }
}
