import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/features/auth/data/auth_credentials.dart';
import 'package:ultistats/features/auth/data/auth_interceptor.dart';

void main() {
  late AuthCredentials credentials;
  late _FakeAdapter adapter;
  late Dio dio;

  setUp(() {
    credentials = AuthCredentials()..installationId = 'installation';
    adapter = _FakeAdapter((options) {
      if (options.uri.path.endsWith('/auth/csrf')) {
        return _json({'headerName': 'X-CSRF-TOKEN', 'token': 'csrf-token'});
      }
      return _json({});
    });
    dio = _createDio(adapter, credentials);
  });

  test('CSRF запрашивается без identity-заголовков', () async {
    await dio.post('/players', data: {});

    final csrfRequest = adapter.requests.first;
    expect(csrfRequest.uri.path, '/api/v1/auth/csrf');
    expect(
      csrfRequest.headers.containsKey('X-UltiStats-Installation-Id'),
      isFalse,
    );
    expect(csrfRequest.headers.containsKey('X-UltiStats-Account-Id'), isFalse);
    expect(csrfRequest.headers.containsKey('X-UltiStats-Session-Id'), isFalse);
  });

  test('небезопасный запрос получает installation и CSRF', () async {
    await dio.post('/players', data: {});

    final request = adapter.requests.last;
    expect(request.method, 'POST');
    expect(request.headers['X-UltiStats-Installation-Id'], 'installation');
    expect(request.headers['X-CSRF-TOKEN'], 'csrf-token');
    expect(request.headers.containsKey('X-UltiStats-Account-Id'), isFalse);
  });

  test('с сессией запрос получает все три identity-заголовка', () async {
    credentials
      ..accountId = 'account'
      ..sessionId = 'session';

    await dio.put('/players/1', data: {});

    final request = adapter.requests.last;
    expect(request.headers['X-UltiStats-Installation-Id'], 'installation');
    expect(request.headers['X-UltiStats-Account-Id'], 'account');
    expect(request.headers['X-UltiStats-Session-Id'], 'session');
    expect(request.headers['X-CSRF-TOKEN'], 'csrf-token');
  });

  test('бутстрап сессии идёт без identity-заголовков', () async {
    await dio.get('/auth/session');

    final request = adapter.requests.single;
    expect(request.headers.containsKey('X-UltiStats-Installation-Id'), isFalse);
    expect(request.headers.containsKey('X-UltiStats-Account-Id'), isFalse);
    expect(request.headers.containsKey('X-UltiStats-Session-Id'), isFalse);
  });

  test('login получает installation, но не заголовки аккаунта', () async {
    credentials
      ..accountId = 'account'
      ..sessionId = 'session';

    await dio.post('/auth/login', data: {'login': 'user', 'password': 'pass'});

    final request = adapter.requests.last;
    expect(request.headers['X-UltiStats-Installation-Id'], 'installation');
    expect(request.headers.containsKey('X-UltiStats-Account-Id'), isFalse);
    expect(request.headers.containsKey('X-UltiStats-Session-Id'), isFalse);
  });

  test('401 разлогинивает и вызывает callback', () async {
    credentials
      ..accountId = 'account'
      ..sessionId = 'session'
      ..csrfToken = 'token';
    var expired = 0;
    credentials.onSessionExpired = () => expired++;
    adapter.handler = (_) => _json({'code': 'AUTH_SESSION_INVALID'}, 401);

    await expectLater(
      dio.post('/players', data: {}),
      throwsA(isA<DioException>()),
    );

    expect(credentials.hasSession, isFalse);
    expect(expired, 1);
  });

  test('CSRF_INVALID обновляет токен и повторяет запрос один раз', () async {
    credentials
      ..accountId = 'account'
      ..sessionId = 'session'
      ..csrfToken = 'stale'
      ..csrfHeaderName = 'X-CSRF-TOKEN';

    var csrfRequests = 0;
    var playerRequests = 0;
    adapter.handler = (options) {
      if (options.uri.path.endsWith('/auth/csrf')) {
        csrfRequests++;
        return _json({
          'headerName': 'X-CSRF-TOKEN',
          'token': 'csrf-$csrfRequests',
        });
      }
      playerRequests++;
      if (playerRequests == 1) {
        return _json({'code': 'CSRF_INVALID'}, 403);
      }
      return _json({});
    };

    final response = await dio.post('/players', data: {});

    expect(response.statusCode, 200);
    expect(csrfRequests, 1);
    expect(playerRequests, 2);
    expect(adapter.requests.last.headers['X-CSRF-TOKEN'], 'csrf-1');
  });

  test('AUTH_PASSWORD_CHANGE_REQUIRED сообщает контроллеру', () async {
    credentials
      ..accountId = 'account'
      ..sessionId = 'session'
      ..csrfToken = 'token';
    var required = 0;
    credentials.onPasswordChangeRequired = () => required++;
    adapter.handler = (_) =>
        _json({'code': 'AUTH_PASSWORD_CHANGE_REQUIRED'}, 403);

    await expectLater(
      dio.post('/players', data: {}),
      throwsA(isA<DioException>()),
    );

    expect(required, 1);
    expect(credentials.hasSession, isTrue);
  });
}

Dio _createDio(_FakeAdapter adapter, AuthCredentials credentials) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://example.test/api/v1',
      headers: {'Content-Type': 'application/json'},
    ),
  );
  dio.httpClientAdapter = adapter;
  dio.interceptors.add(AuthInterceptor(dio: dio, credentials: credentials));
  return dio;
}

ResponseBody _json(Object body, [int statusCode = 200]) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  FutureOr<ResponseBody> Function(RequestOptions options) handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}
