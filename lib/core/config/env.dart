abstract class Env {
  static const String urlDev = String.fromEnvironment('BASE_URL_DEV');
  static const String urlStg = String.fromEnvironment('BASE_URL_STG');
  static const String urlProd = String.fromEnvironment('BASE_URL_PROD');

  /// DSN проекта Sentry. Пустая строка отключает отправку на сервер.
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');
}
