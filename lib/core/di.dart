import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/config/config.dart';

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

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
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
