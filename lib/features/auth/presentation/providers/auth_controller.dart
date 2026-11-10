import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/logging/app_logger.dart';
import 'package:ultistats/features/auth/domain/entities/auth_exception.dart';
import 'package:ultistats/features/auth/domain/entities/auth_session.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  /// Не продлеваем сессию чаще раза в минуту: этого требует контракт сервера,
  /// и так мы не тратим лишние запросы на каждое нажатие.
  static const _renewInterval = Duration(minutes: 1);

  DateTime? _lastRenewAt;

  @override
  Future<AuthSession> build() async {
    final credentials = ref.watch(authCredentialsProvider);

    credentials.onSessionExpired = _onSessionExpired;
    credentials.onPasswordChangeRequired = _onPasswordChangeRequired;
    ref.onDispose(() {
      credentials.onSessionExpired = null;
      credentials.onPasswordChangeRequired = null;
    });

    return ref.watch(authRepositoryProvider).restore();
  }

  Future<AuthSession> login({
    required String login,
    required String password,
  }) async {
    final session = await ref
        .read(authRepositoryProvider)
        .login(login: login, password: password);
    if (ref.mounted) state = AsyncData(session);
    return session;
  }

  Future<AuthSession> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final session = await ref
        .read(authRepositoryProvider)
        .changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
    if (ref.mounted) state = AsyncData(session);
    return session;
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    if (!ref.mounted) return;

    final installationId = ref.read(authCredentialsProvider).installationId;
    state = AsyncData(AuthSession.anonymous(installationId: installationId));
  }

  /// Вызывается на действия пользователя. Ошибки сети не разлогинивают:
  /// сессия ещё может быть жива, а продление повторится позже.
  Future<void> noteActivity() async {
    final session = state.value;
    if (session == null || !session.isAuthenticated) return;

    final now = DateTime.now();
    final lastRenewAt = _lastRenewAt;
    if (lastRenewAt != null && now.difference(lastRenewAt) < _renewInterval) {
      return;
    }
    _lastRenewAt = now;

    try {
      final renewed = await ref.read(authRepositoryProvider).renew();
      if (ref.mounted) state = AsyncData(renewed);
    } on AuthException catch (error) {
      if (error.isSessionInvalid) _onSessionExpired();
    } catch (error, stackTrace) {
      log(
        'Failed to renew session',
        error: error,
        stackTrace: stackTrace,
        name: runtimeType.toString(),
        level: AppLogLevel.warning,
      );
    }
  }

  /// Повторная попытка восстановить сессию после сетевой ошибки.
  Future<void> retryRestore() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).restore(),
    );
  }

  void _onSessionExpired() {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      AuthSession.anonymous(installationId: current.installationId),
    );
  }

  Future<void> _onPasswordChangeRequired() async {
    try {
      final session = await ref.read(authRepositoryProvider).restore();
      if (ref.mounted) state = AsyncData(session);
    } catch (error, stackTrace) {
      log(
        'Failed to refresh session after password change requirement',
        error: error,
        stackTrace: stackTrace,
        name: runtimeType.toString(),
        level: AppLogLevel.warning,
      );
    }
  }
}
