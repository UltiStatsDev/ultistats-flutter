import 'package:ultistats/features/auth/domain/entities/auth_session.dart';

abstract class AuthRepository {
  /// Восстанавливает сессию по сохранённой cookie.
  Future<AuthSession> restore();

  Future<AuthSession> login({required String login, required String password});

  Future<AuthSession> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Продлевает сессию после действия пользователя.
  Future<AuthSession> renew();

  Future<void> logout();
}
