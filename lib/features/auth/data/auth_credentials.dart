import 'package:ultistats/features/auth/domain/entities/auth_session.dart';

/// Учётные данные, которые нужны HTTP-клиенту на каждом запросе.
///
/// Токены живут только в памяти. HttpOnly-cookie сессии хранится в
/// [CookieStore] и недоступна коду приложения.
class AuthCredentials {
  String? installationId;
  String? accountId;
  String? sessionId;
  String? csrfHeaderName;
  String? csrfToken;

  /// Вызывается, когда сервер сообщил, что сессия больше не действует.
  void Function()? onSessionExpired;

  /// Вызывается, когда сервер требует сменить временный пароль.
  void Function()? onPasswordChangeRequired;

  bool get hasSession => accountId != null && sessionId != null;

  void applySession(AuthSession session) {
    installationId = session.installationId ?? installationId;
    accountId = session.account?.id;
    sessionId = session.sessionId;
  }

  void clearCsrf() {
    csrfHeaderName = null;
    csrfToken = null;
  }

  void clearSession() {
    accountId = null;
    sessionId = null;
    clearCsrf();
  }
}
