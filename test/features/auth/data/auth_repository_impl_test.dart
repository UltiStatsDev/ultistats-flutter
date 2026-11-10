import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/network/cookie_store.dart';
import 'package:ultistats/features/auth/data/auth_credentials.dart';
import 'package:ultistats/features/auth/data/models/account_model.dart';
import 'package:ultistats/features/auth/data/models/auth_context_model.dart';
import 'package:ultistats/features/auth/data/models/installation_model.dart';
import 'package:ultistats/features/auth/data/models/logout_result_model.dart';
import 'package:ultistats/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ultistats/features/auth/data/requests/change_password_request.dart';
import 'package:ultistats/features/auth/data/requests/expected_session_request.dart';
import 'package:ultistats/features/auth/data/requests/login_request.dart';
import 'package:ultistats/features/auth/data/sources/auth_api.dart';
import 'package:ultistats/features/auth/domain/entities/auth_exception.dart';
import 'package:ultistats/features/auth/domain/entities/auth_permission.dart';
import 'package:ultistats/features/auth/domain/entities/auth_session.dart';

void main() {
  late FakeAuthApi api;
  late AuthCredentials credentials;
  late FakeCookieStore cookies;
  late AuthRepositoryImpl repository;

  setUp(() {
    api = FakeAuthApi();
    credentials = AuthCredentials();
    cookies = FakeCookieStore();
    repository = AuthRepositoryImpl(
      api: api,
      credentials: credentials,
      cookies: cookies,
    );
  });

  test('restore восстанавливает сессию и identity-заголовки', () async {
    api.session = _context();

    final session = await repository.restore();

    expect(session.status, AuthStatus.authenticated);
    expect(session.account?.login, 'organizer');
    expect(session.permissions, contains(AuthPermission.sportsWrite));
    expect(credentials.installationId, 'installation');
    expect(credentials.accountId, 'account');
    expect(credentials.sessionId, 'session');
  });

  test('restore без cookie остаётся анонимным', () async {
    api.session = _context(state: 'ANONYMOUS');

    final session = await repository.restore();

    expect(session.status, AuthStatus.anonymous);
    expect(credentials.installationId, 'installation');
    expect(credentials.hasSession, isFalse);
    expect(cookies.cleared, isFalse);
  });

  test('restore удаляет cookie протухшей сессии', () async {
    api.sessionError = _dioError(401, 'AUTH_SESSION_INVALID');

    final session = await repository.restore();

    expect(session.status, AuthStatus.anonymous);
    expect(cookies.cleared, isTrue);
    expect(credentials.hasSession, isFalse);
  });

  test('login сохраняет identity и сбрасывает CSRF-токен', () async {
    api.loginResult = _context();
    credentials.csrfToken = 'stale';

    final session = await repository.login(
      login: 'organizer',
      password: 'secret-password',
    );

    expect(session.status, AuthStatus.authenticated);
    expect(api.loginRequest?.login, 'organizer');
    expect(credentials.accountId, 'account');
    expect(credentials.sessionId, 'session');
    expect(credentials.csrfToken, isNull);
  });

  test('login без installationId сначала получает его', () async {
    api.loginResult = _context();

    await repository.login(login: 'organizer', password: 'secret-password');

    expect(api.installationRequests, 1);
    expect(credentials.installationId, 'installation');
  });

  test('ошибка входа превращается в AuthException', () async {
    api.loginError = _dioError(401, 'AUTH_CREDENTIALS_INVALID');

    await expectLater(
      repository.login(login: 'organizer', password: 'wrong'),
      throwsA(
        isA<AuthException>()
            .having((e) => e.code, 'code', 'AUTH_CREDENTIALS_INVALID')
            .having((e) => e.message, 'message', contains('Неверный логин')),
      ),
    );
  });

  test('changePassword применяет новый контекст', () async {
    api.changePasswordResult = _context(permissions: const ['SPORTS_WRITE']);
    credentials.csrfToken = 'stale';

    final session = await repository.changePassword(
      currentPassword: 'temporary',
      newPassword: 'new-password',
    );

    expect(session.status, AuthStatus.authenticated);
    expect(session.permissions, contains(AuthPermission.sportsWrite));
    expect(credentials.csrfToken, isNull);
  });

  test('logout очищает cookie и локальную сессию', () async {
    credentials
      ..installationId = 'installation'
      ..accountId = 'account'
      ..sessionId = 'session';

    await repository.logout();

    expect(api.logoutRequest?.expectedSessionId, 'session');
    expect(cookies.cleared, isTrue);
    expect(credentials.hasSession, isFalse);
  });

  test('logout выходит локально, даже если запрос упал', () async {
    credentials
      ..installationId = 'installation'
      ..accountId = 'account'
      ..sessionId = 'session';
    api.logoutError = _dioError(500);

    await repository.logout();

    expect(cookies.cleared, isTrue);
    expect(credentials.hasSession, isFalse);
  });

  test('renew обновляет контекст сессии', () async {
    credentials
      ..installationId = 'installation'
      ..accountId = 'account'
      ..sessionId = 'session';
    api.renewResult = _context();

    final session = await repository.renew();

    expect(session.status, AuthStatus.authenticated);
    expect(api.renewRequest?.expectedSessionId, 'session');
  });
}

AuthContextModel _context({
  String state = 'AUTHENTICATED',
  List<String> permissions = const ['SPORTS_WRITE'],
}) {
  final isAnonymous = state == 'ANONYMOUS';
  return AuthContextModel(
    contractVersion: '1.0.0',
    installationId: 'installation',
    serverNow: DateTime.utc(2026, 1, 1),
    state: state,
    sessionId: isAnonymous ? null : 'session',
    account: isAnonymous ? null : _account(),
    permissions: isAnonymous ? const [] : permissions,
    lastActivityAt: null,
    idleExpiresAt: null,
    reauthenticatedUntil: null,
    replacedSessionId: null,
  );
}

AccountModel _account() {
  return AccountModel(
    id: 'account',
    login: 'organizer',
    displayName: 'Организатор',
    role: 'ORGANIZER',
    status: 'ACTIVE',
    mustChangePassword: false,
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );
}

DioException _dioError(int statusCode, [String? code]) {
  final options = RequestOptions(path: '/auth/session');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: options,
      statusCode: statusCode,
      data: code == null ? null : {'code': code},
    ),
  );
}

class FakeCookieStore implements CookieStore {
  bool cleared = false;

  @override
  void attach(Dio dio) {}

  @override
  Future<void> clear() async {
    cleared = true;
  }
}

class FakeAuthApi implements AuthApi {
  InstallationModel installation = const InstallationModel(
    contractVersion: '1.0.0',
    installationId: 'installation',
    entryMode: 'SECURE',
    publicOrigin: 'https://example.test',
    secureOrigin: 'https://example.test',
  );
  AuthContextModel session = _context(state: 'ANONYMOUS');
  AuthContextModel loginResult = _context();
  AuthContextModel changePasswordResult = _context();
  AuthContextModel renewResult = _context();
  LogoutResultModel logoutResult = const LogoutResultModel(
    sessionId: 'session',
    status: 'REVOKED',
  );

  Object? sessionError;
  Object? loginError;
  Object? changePasswordError;
  Object? renewError;
  Object? logoutError;

  LoginRequest? loginRequest;
  ExpectedSessionRequest? renewRequest;
  ExpectedSessionRequest? logoutRequest;
  ChangePasswordRequest? changePasswordRequest;
  int installationRequests = 0;

  @override
  Future<InstallationModel> getInstallation() async {
    installationRequests++;
    return installation;
  }

  @override
  Future<AuthContextModel> getSession() async {
    final error = sessionError;
    if (error != null) throw error;
    return session;
  }

  @override
  Future<AuthContextModel> login(LoginRequest body) async {
    loginRequest = body;
    final error = loginError;
    if (error != null) throw error;
    return loginResult;
  }

  @override
  Future<AuthContextModel> changePassword(ChangePasswordRequest body) async {
    changePasswordRequest = body;
    final error = changePasswordError;
    if (error != null) throw error;
    return changePasswordResult;
  }

  @override
  Future<AuthContextModel> renew(ExpectedSessionRequest body) async {
    renewRequest = body;
    final error = renewError;
    if (error != null) throw error;
    return renewResult;
  }

  @override
  Future<LogoutResultModel> logout(ExpectedSessionRequest body) async {
    logoutRequest = body;
    final error = logoutError;
    if (error != null) throw error;
    return logoutResult;
  }
}
