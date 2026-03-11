import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ultistats/features/players/data/sources/players_api.dart';
import 'package:ultistats/features/teams/data/sources/teams_api.dart';
import 'package:ultistats/features/matches/data/sources/matches_api.dart';

import 'package:ultistats/features/players/domain/repositories/players_repository.dart';
import 'package:ultistats/features/teams/domain/repositories/teams_repository.dart';
import 'package:ultistats/features/matches/domain/repositories/matches_repository.dart';

import 'package:ultistats/features/players/data/repositories/players_repository_impl.dart';
import 'package:ultistats/features/teams/data/repositories/teams_repository_impl.dart';
import 'package:ultistats/features/matches/data/repositories/matches_repository_impl.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://your-api-url.com', // ЗАМЕНИ на свой реальный URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  // Добавляем логгер для удобной отладки в консоли
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

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
