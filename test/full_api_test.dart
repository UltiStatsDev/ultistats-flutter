import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/features/matches/data/repositories/match_events_repository_impl.dart';
import 'package:ultistats/features/matches/data/repositories/match_statistics_repository_impl.dart';
import 'package:ultistats/features/matches/data/repositories/matches_repository_impl.dart';
import 'package:ultistats/features/matches/data/sources/match_events_api.dart';
import 'package:ultistats/features/matches/data/sources/match_statistics_api.dart';
import 'package:ultistats/features/matches/data/sources/matches_api.dart';
import 'package:ultistats/features/matches/domain/entities/match_event.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';
import 'package:ultistats/features/players/data/repositories/players_repository_impl.dart';
import 'package:ultistats/features/players/data/sources/players_api.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';
import 'package:ultistats/features/teams/data/repositories/teams_repository_impl.dart';
import 'package:ultistats/features/teams/data/sources/teams_api.dart';
import 'package:ultistats/features/teams/domain/params/create_team_params.dart';
import 'package:ultistats/features/teams/domain/params/team_filter_params.dart';
import 'package:ultistats/features/teams/domain/params/update_team_params.dart';

void main() {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080',
    connectTimeout: const Duration(seconds: 10),
  ));

  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  // Инициализация всех репозиториев
  final playersRepo = PlayersRepositoryImpl(PlayersApi(dio));
  final teamsRepo = TeamsRepositoryImpl(TeamsApi(dio));
  final matchesRepo = MatchesRepositoryImpl(MatchesApi(dio));
  final eventsRepo = MatchEventsRepositoryImpl(MatchEventsApi(dio));
  final statsRepo = MatchStatisticsRepositoryImpl(MatchStatisticsApi(dio));

  group('Full System Smoke Test', () {
    late String createdPlayerId;
    late String createdTeamId;
    late String createdMatchId;

    test('1. Players Flow (Create -> Get -> Update -> Delete)', () async {
      // Create
      final player = await playersRepo.createPlayer(const CreatePlayerParams(
        firstName: 'Test',
        lastName: 'Player',
        number: 99,
        teamId: '00000000-0000-0000-0000-000000000000', // Временный ID или существующий
      ));
      createdPlayerId = player.id;
      expect(player.firstName, 'Test');

      // Get
      final fetched = await playersRepo.getById(createdPlayerId);
      expect(fetched.id, createdPlayerId);

      // List
      final list = await playersRepo.getList(const PlayerFilterParams(size: 1));
      expect(list.content, isNotEmpty);

      // Update
      final updated = await playersRepo.updateById(UpdatePlayerParams(
        playerId: createdPlayerId,
        firstName: 'UpdatedName',
      ));
      expect(updated.firstName, 'UpdatedName');

      // Delete
      await playersRepo.deleteById(createdPlayerId);
    });

    test('2. Teams Flow (Create -> Get -> Update -> Delete)', () async {
      // Create
      final team = await teamsRepo.createTeam(const CreateTeamParams(
        name: 'Smoke Test Team',
        playerIds: [],
      ));
      createdTeamId = team.id;
      expect(team.name, 'Smoke Test Team');

      // Get & List
      await teamsRepo.getById(createdTeamId);
      await teamsRepo.getList(const TeamFilterParams(name: 'Smoke'));

      // Update
      await teamsRepo.updateById(UpdateTeamParams(
        teamId: createdTeamId,
        name: 'New Team Name',
      ));

      // Cleanup
      await teamsRepo.deleteById(createdTeamId);
    });

    test('3. Matches Full Scenario', () async {
      // 3.1 Create Team first (need it for match)
      final team = await teamsRepo.createTeam(const CreateTeamParams(
        name: 'Match Team',
        playerIds: [],
      ));
      createdTeamId = team.id;

      // 3.2 Create Match
      final match = await matchesRepo.createMatch(CreateMatchParams(
        teamIds: [createdTeamId],
        plannedStartDate: DateTime.now().add(const Duration(days: 1)),
      ));
      createdMatchId = match.id;

      // 3.3 Start & End Match
      await matchesRepo.startMatch(createdMatchId, DateTime.now());
      await matchesRepo.endMatch(createdMatchId, DateTime.now());

      // 3.4 Events Flow
      await eventsRepo.addEvent(CreateEventParams(
        matchId: createdMatchId,
        type: MatchEventType.GOAL,
        timestamp: DateTime.now(),
        teamId: createdTeamId,
        playerId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        toPlayerId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        toTeamId: createdTeamId
      ));

      final events = await eventsRepo.getEvents(createdMatchId);
      expect(events, isNotEmpty);

      await eventsRepo.deleteEvent(createdMatchId, 0);

      // 3.5 Statistics
      final stats = await statsRepo.getStatistics(createdMatchId);
      expect(stats.teamStatistics, isNotEmpty);

      // 3.6 Cleanup
      await matchesRepo.deleteById(createdMatchId);
      await teamsRepo.deleteById(createdTeamId);
    });
  });
}