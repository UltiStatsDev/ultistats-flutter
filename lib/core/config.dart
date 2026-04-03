import 'package:flutter/services.dart';

abstract class AppConfig {
  static String get baseUrl {
    switch (appFlavor) {
      case 'prod':
        return 'https://api.ultistats.com/api/v1';
      case 'staging':
        return 'https://staging-api.ultistats.com/api/v1';
      case 'dev':
      default:
        return 'http://10.0.2.2:8080/api/v1';
    }
  }

  static bool get isDev => appFlavor == 'dev';
  static bool get isProd => appFlavor == 'prod';
  static bool get isStaging => appFlavor == 'staging';
}
