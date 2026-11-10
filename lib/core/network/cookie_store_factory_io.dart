import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:ultistats/core/config/config.dart';

import 'cookie_store.dart';

CookieStore createCookieStore(String? supportDirectory) {
  final CookieJar jar = switch (supportDirectory) {
    final directory? when directory.isNotEmpty => PersistCookieJar(
      ignoreExpires: false,
      storage: FileStorage('$directory/cookies'),
    ),
    _ => CookieJar(ignoreExpires: false),
  };

  return _PersistentCookieStore(jar);
}

class _PersistentCookieStore implements CookieStore {
  _PersistentCookieStore(this._jar);

  final CookieJar _jar;

  @override
  void attach(Dio dio) {
    dio.interceptors.add(CookieManager(_jar));
  }

  @override
  Future<void> clear() => _jar.delete(Uri.parse(AppConfig.baseUrl));
}
