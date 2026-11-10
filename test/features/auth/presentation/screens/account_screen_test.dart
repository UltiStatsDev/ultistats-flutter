import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/auth/domain/entities/account.dart';
import 'package:ultistats/features/auth/domain/entities/auth_permission.dart';
import 'package:ultistats/features/auth/domain/entities/auth_session.dart';
import 'package:ultistats/features/auth/domain/repositories/auth_repository.dart';
import 'package:ultistats/features/auth/presentation/screens/account_screen.dart';

void main() {
  testWidgets('гость видит предложение войти', (tester) async {
    await _pump(tester, repository: _FakeAuthRepository());

    expect(find.text('Вы не вошли в аккаунт'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Войти'), findsOneWidget);
  });

  testWidgets('вошедший пользователь видит данные аккаунта', (tester) async {
    await _pump(
      tester,
      repository: _FakeAuthRepository()..restoreResult = _authenticated(),
    );

    expect(find.text('Иван Организатор'), findsOneWidget);
    expect(find.text('organizer'), findsOneWidget);
    expect(find.text('Организатор'), findsOneWidget);
    expect(find.text('Доступно редактирование данных'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Выйти'), findsOneWidget);
  });

  testWidgets('без права записи показывает режим просмотра', (tester) async {
    await _pump(
      tester,
      repository: _FakeAuthRepository()
        ..restoreResult = _authenticated(permissions: const {}),
    );

    expect(find.text('Доступен только просмотр данных'), findsOneWidget);
  });

  testWidgets('ошибка восстановления сессии предлагает повторить', (
    tester,
  ) async {
    await _pump(
      tester,
      repository: _FakeAuthRepository()
        ..restoreError = Exception('network is down'),
    );

    expect(find.text('Не удалось проверить сессию'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Повторить'), findsOneWidget);
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required _FakeAuthRepository repository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        theme: createLightTheme(),
        home: const Scaffold(body: AccountScreen()),
      ),
    ),
  );
  // Даём провайдеру завершить восстановление сессии.
  await tester.pumpAndSettle();
}

AuthSession _authenticated({
  Set<AuthPermission> permissions = const {AuthPermission.sportsWrite},
}) {
  return AuthSession(
    status: AuthStatus.authenticated,
    installationId: 'installation',
    sessionId: 'session',
    account: Account(
      id: 'account',
      login: 'organizer',
      displayName: 'Иван Организатор',
      role: AccountRole.organizer,
      status: AccountStatus.active,
      mustChangePassword: false,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    ),
    permissions: permissions,
  );
}

class _FakeAuthRepository implements AuthRepository {
  AuthSession restoreResult = const AuthSession.anonymous();
  Object? restoreError;

  @override
  Future<AuthSession> restore() async {
    final error = restoreError;
    if (error != null) throw error;
    return restoreResult;
  }

  @override
  Future<AuthSession> login({
    required String login,
    required String password,
  }) async => restoreResult;

  @override
  Future<AuthSession> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async => restoreResult;

  @override
  Future<AuthSession> renew() async => restoreResult;

  @override
  Future<void> logout() async {}
}
