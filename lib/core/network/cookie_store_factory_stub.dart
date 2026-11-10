import 'package:dio/dio.dart';

import 'cookie_store.dart';

/// На web cookie хранит браузер, отдельное хранилище не нужно.
CookieStore createCookieStore(String? supportDirectory) =>
    _BrowserCookieStore();

class _BrowserCookieStore implements CookieStore {
  @override
  void attach(Dio dio) {}

  @override
  Future<void> clear() async {}
}
