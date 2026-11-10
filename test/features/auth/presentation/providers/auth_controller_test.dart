import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/auth/domain/entities/account.dart';
import 'package:ultistats/features/auth/domain/entities/auth_exception.dart';
import 'package:ultistats/features/auth/domain/entities/auth_permission.dart';
import 'package:ultistats/features/auth/domain/entities/auth_session.dart';
import 'package:ultistats/features/auth/domain/repositories/auth_repository.dart';
import 'package:ultistats/features/auth/presentation/providers/auth_controller.dart';

void main() {
  late _FakeAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _FakeAuthRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  test('build восстанавливает сессию', () async {
    final session = await container.read(authControllerProvider.future);

    expect(session.status, AuthStatus.authenticated);
    expect(
      container.read(authControllerProvider).value?.account?.login,
      'organizer',
    );
  });

  test('login обновляет состояние', () async {
    await container.read(authControllerProvider.future);
    repository.loginResult = _session();

    final session = await container
        .read(authControllerProvider.notifier)
        .login(login: 'organizer', password: 'password');

    expect(session.isAuthenticated, isTrue);
    expect(
      container.read(authControllerProvider).value?.isAuthenticated,
      isTrue,
    );
  });

  test('logout переводит в анонимное состояние', () async {
    await container.read(authControllerProvider.future);

    await container.read(authControllerProvider.notifier).logout();

    final state = container.read(authControllerProvider).value;
    expect(state?.status, AuthStatus.anonymous);
    expect(repository.logoutCalls, 1);
  });

  test('истёкшая сессия переводит в анонимное состояние', () async {
    await container.read(authControllerProvider.future);
    final credentials = container.read(authCredentialsProvider);

    credentials.onSessionExpired!();

    final state = container.read(authControllerProvider).value;
    expect(state?.status, AuthStatus.anonymous);
  });

  test('активность продлевает сессию не чаще раза в минуту', () async {
    await container.read(authControllerProvider.future);
    final notifier = container.read(authControllerProvider.notifier);

    await notifier.noteActivity();
    await notifier.noteActivity();

    expect(repository.renewCalls, 1);
  });

  test('401 при продлении разлогинивает', () async {
    await container.read(authControllerProvider.future);
    repository.renewError = const AuthException(
      message: 'Сессия истекла',
      statusCode: 401,
      code: 'AUTH_SESSION_INVALID',
    );

    await container.read(authControllerProvider.notifier).noteActivity();

    expect(
      container.read(authControllerProvider).value?.status,
      AuthStatus.anonymous,
    );
  });
}

AuthSession _session() {
  return AuthSession(
    status: AuthStatus.authenticated,
    installationId: 'installation',
    sessionId: 'session',
    account: Account(
      id: 'account',
      login: 'organizer',
      displayName: 'Организатор',
      role: AccountRole.organizer,
      status: AccountStatus.active,
      mustChangePassword: false,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    ),
    permissions: const {AuthPermission.sportsWrite},
  );
}

class _FakeAuthRepository implements AuthRepository {
  AuthSession restoreResult = _session();
  AuthSession loginResult = _session();
  AuthSession changePasswordResult = _session();
  AuthSession renewResult = _session();
  Object? renewError;

  int logoutCalls = 0;
  int renewCalls = 0;

  @override
  Future<AuthSession> restore() async => restoreResult;

  @override
  Future<AuthSession> login({
    required String login,
    required String password,
  }) async => loginResult;

  @override
  Future<AuthSession> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async => changePasswordResult;

  @override
  Future<AuthSession> renew() async {
    renewCalls++;
    final error = renewError;
    if (error != null) throw error;
    return renewResult;
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
  }
}
