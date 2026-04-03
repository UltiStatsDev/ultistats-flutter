abstract class Env {
  static const String urlDev = String.fromEnvironment('BASE_URL_DEV');
  static const String urlStg = String.fromEnvironment('BASE_URL_STG');
  static const String urlProd = String.fromEnvironment('BASE_URL_PROD');
}