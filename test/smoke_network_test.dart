import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/features/players/data/repositories/players_repository_impl.dart';
import 'package:ultistats/features/players/data/sources/players_api.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';
import 'package:ultistats/features/teams/data/repositories/teams_repository_impl.dart';
import 'package:ultistats/features/teams/data/sources/teams_api.dart';
import 'package:ultistats/features/teams/domain/params/team_filter_params.dart';
import 'package:ultistats/features/matches/data/repositories/matches_repository_impl.dart';
import 'package:ultistats/features/matches/data/sources/matches_api.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';

void main() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  final playersApi = PlayersApi(dio);
  final playersRepo = PlayersRepositoryImpl(playersApi);

  final teamsApi = TeamsApi(dio);
  final teamsRepo = TeamsRepositoryImpl(teamsApi);

  final matchesApi = MatchesApi(dio);
  final matchesRepo = MatchesRepositoryImpl(matchesApi);

  group('Real API Smoke Tests (Integration)', () {

    test('Players: getList returns 200 and valid Page', () async {
      final result = await playersRepo.getList(const PlayerFilterParams(page: 0, size: 5));

      expect(result.content, isA<List>());
      print('✅ Players API is UP. Found ${result.totalElements} players.');
    });

    test('Teams: getList returns 200 and valid Page', () async {
      final result = await teamsRepo.getList(const TeamFilterParams(page: 0, size: 5));

      expect(result.content, isA<List>());
      print('✅ Teams API is UP. Found ${result.totalElements} teams.');
    });

    test('Matches: getList returns 200 and valid Page', () async {
      final result = await matchesRepo.getList(const MatchFilterParams(page: 0, size: 5));

      expect(result.content, isA<List>());
      print('✅ Matches API is UP. Found ${result.totalElements} matches.');
    });
  });
}