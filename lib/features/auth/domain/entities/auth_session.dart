import 'package:ultistats/features/auth/domain/entities/account.dart';
import 'package:ultistats/features/auth/domain/entities/auth_permission.dart';

enum AuthStatus { anonymous, authenticated, passwordChangeRequired }

class AuthSession {
  const AuthSession({
    required this.status,
    this.installationId,
    this.sessionId,
    this.account,
    this.permissions = const {},
    this.lastActivityAt,
    this.idleExpiresAt,
    this.reauthenticatedUntil,
    this.replacedSessionId,
  });

  const AuthSession.anonymous({this.installationId})
    : status = AuthStatus.anonymous,
      sessionId = null,
      account = null,
      permissions = const {},
      lastActivityAt = null,
      idleExpiresAt = null,
      reauthenticatedUntil = null,
      replacedSessionId = null;

  final AuthStatus status;
  final String? installationId;
  final String? sessionId;
  final Account? account;
  final Set<AuthPermission> permissions;
  final DateTime? lastActivityAt;
  final DateTime? idleExpiresAt;
  final DateTime? reauthenticatedUntil;
  final String? replacedSessionId;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  bool get mustChangePassword => status == AuthStatus.passwordChangeRequired;

  bool hasPermission(AuthPermission permission) =>
      permissions.contains(permission);

  /// Может ли пользователь создавать, изменять и удалять спортивные данные.
  bool get canWriteSports =>
      isAuthenticated && hasPermission(AuthPermission.sportsWrite);
}
