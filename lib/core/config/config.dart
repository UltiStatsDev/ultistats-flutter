import 'package:flutter/services.dart';
import 'package:ultistats/core/config/env.dart';

abstract class AppConfig {
  static String get baseUrl => switch (appFlavor) {
        'staging' => Env.urlStg,
        'prod' => Env.urlProd,
        'dev' => Env.urlDev,
        _ => Env.urlDev,
      };

  static bool get isDev => appFlavor == 'dev';
  static bool get isProd => appFlavor == 'prod';
  static bool get isStaging => appFlavor == 'staging';

  static String get photoServerUrl => Uri.parse(baseUrl).origin;
}
