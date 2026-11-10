import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/config/app_storage.dart';
import 'package:ultistats/core/config/config.dart';
import 'package:ultistats/core/logging/app_logger.dart';
import 'package:ultistats/core/network/cookie_store.dart';
import 'package:ultistats/core/network/cookie_store_factory.dart';

import 'package:ultistats/features/auth/data/auth_credentials.dart';
import 'package:ultistats/features/auth/data/auth_interceptor.dart';
import 'package:ultistats/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ultistats/features/auth/data/sources/auth_api.dart';
import 'package:ultistats/features/auth/domain/repositories/auth_repository.dart';

import 'package:ultistats/features/players/data/sources/players_api.dart';
import 'package:ultistats/features/teams/data/sources/teams_api.dart';
import 'package:ultistats/features/matches/data/sources/matches_api.dart';
import 'package:ultistats/features/matches/data/sources/match_events_api.dart';
import 'package:ultistats/features/matches/data/sources/match_statistics_api.dart';

import 'package:ultistats/features/players/domain/repositories/players_repository.dart';
import 'package:ultistats/features/teams/domain/repositories/teams_repository.dart';
import 'package:ultistats/features/matches/domain/repositories/matches_repository.dart';
import 'package:ultistats/features/matches/domain/repositories/match_events_repository.dart';
import 'package:ultistats/features/matches/domain/repositories/match_statistics_repository.dart';

import 'package:ultistats/features/players/data/repositories/players_repository_impl.dart';
import 'package:ultistats/features/teams/data/repositories/teams_repository_impl.dart';
import 'package:ultistats/features/matches/data/repositories/matches_repository_impl.dart';
import 'package:ultistats/features/matches/data/repositories/match_events_repository_impl.dart';
import 'package:ultistats/features/matches/data/repositories/match_statistics_repository_impl.dart';
import 'package:ultistats/features/match_game/data/match_event_queue.dart';

const _requestStartKey = 'requestStartedAt';

// =============================================================================
// Аутентификация
// =============================================================================

final authCredentialsProvider = Provider<AuthCredentials>((ref) {
  return AuthCredentials();
});

final cookieStoreProvider = Provider<CookieStore>((ref) {
  return createCookieStore(AppStorage.supportDirectory);
});

final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthApi(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    api: ref.watch(authApiProvider),
    credentials: ref.watch(authCredentialsProvider),
    cookies: ref.watch(cookieStoreProvider),
  );
});

final dioProvider = Provider<Dio>((ref) {
  final credentials = ref.watch(authCredentialsProvider);
  final cookieStore = ref.watch(cookieStoreProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      // На web без этого браузер не отправит и не сохранит cookie сессии
      // в кросс-доменных запросах. На нативных платформах флаг игнорируется.
      extra: const {'withCredentials': true},
    ),
  );

  cookieStore.attach(dio);
  dio.interceptors.add(AuthInterceptor(dio: dio, credentials: credentials));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.extra[_requestStartKey] = DateTime.now();
        log(
          '→ ${options.method} ${options.uri}',
          name: 'HTTP',
          level: AppLogLevel.debug,
        );
        handler.next(options);
      },
      onResponse: (response, handler) {
        final startedAt = response.requestOptions.extra[_requestStartKey];
        final elapsed = startedAt is DateTime
            ? DateTime.now().difference(startedAt).inMilliseconds
            : null;
        log(
          '← ${response.statusCode} ${response.requestOptions.method} '
          '${response.requestOptions.uri}'
          '${elapsed == null ? '' : ' (${elapsed}ms)'}',
          name: 'HTTP',
          level: AppLogLevel.debug,
        );
        handler.next(response);
      },
      onError: (error, handler) {
        final statusCode = error.response?.statusCode;
        final isClientError =
            statusCode != null && statusCode >= 400 && statusCode < 500;
        log(
          '✕ ${error.requestOptions.method} ${error.requestOptions.uri} '
          'failed (${error.type.name}'
          '${statusCode == null ? '' : ', HTTP $statusCode'})',
          error: error,
          stackTrace: error.stackTrace,
          name: 'HTTP',
          level: isClientError ? AppLogLevel.warning : AppLogLevel.error,
        );
        handler.next(error);
      },
    ),
  );

  return dio;
});

// =============================================================================
// API Провайдеры (Data Sources)
// =============================================================================

final playersApiProvider = Provider<PlayersApi>((ref) {
  final dio = ref.watch(dioProvider);
  return PlayersApi(dio);
});

final teamsApiProvider = Provider<TeamsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return TeamsApi(dio);
});

final matchesApiProvider = Provider<MatchesApi>((ref) {
  final dio = ref.watch(dioProvider);
  return MatchesApi(dio);
});

final matchEventsApiProvider = Provider<EventsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return EventsApi(dio);
});

final matchStatisticsApiProvider = Provider<MatchStatisticsApi>((ref) {
  final dio = ref.watch(dioProvider);
  return MatchStatisticsApi(dio);
});

// =============================================================================
// Repository Провайдеры
// =============================================================================

final playersRepositoryProvider = Provider<PlayersRepository>((ref) {
  final api = ref.watch(playersApiProvider);
  return PlayersRepositoryImpl(api);
});

final teamsRepositoryProvider = Provider<TeamsRepository>((ref) {
  final api = ref.watch(teamsApiProvider);
  return TeamsRepositoryImpl(api);
});

final matchesRepositoryProvider = Provider<MatchesRepository>((ref) {
  final api = ref.watch(matchesApiProvider);
  return MatchesRepositoryImpl(api);
});

final matchEventsRepositoryProvider = Provider<MatchEventsRepository>((ref) {
  final api = ref.watch(matchEventsApiProvider);
  return MatchEventsRepositoryImpl(api);
});

final matchStatisticsRepositoryProvider = Provider<MatchStatisticsRepository>((
  ref,
) {
  final api = ref.watch(matchStatisticsApiProvider);
  return MatchStatisticsRepositoryImpl(api);
});

// =============================================================================
// Сервисы
// =============================================================================

final matchEventQueueProvider = Provider<MatchEventQueue>((ref) {
  return MatchEventQueue(ref.read(matchEventsRepositoryProvider));
});
