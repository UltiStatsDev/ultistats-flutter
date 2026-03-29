import 'package:dio/dio.dart';
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

Future<void> runFullApiTest() async {
  print('=== STARTING FULL API TEST ===\n');

  final dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.0.32:8080',
    connectTimeout: const Duration(seconds: 10),
  ));

  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  final playersRepo = PlayersRepositoryImpl(PlayersApi(dio));
  final teamsRepo = TeamsRepositoryImpl(TeamsApi(dio));
  final matchesRepo = MatchesRepositoryImpl(MatchesApi(dio));
  final eventsRepo = MatchEventsRepositoryImpl(MatchEventsApi(dio));
  final statsRepo = MatchStatisticsRepositoryImpl(MatchStatisticsApi(dio));

  String createdPlayerId = '';
  String createdTeamId = '';
  String createdMatchId = '';

  try {
    // 1. Players Flow
    print('--- TEST 1: Players Flow ---');

    final player = await playersRepo.createPlayer(const CreatePlayerParams(
      firstName: 'Test',
      lastName: 'Player',
      number: 99,
      teamId: '00000000-0000-0000-0000-000000000000',
    ));
    createdPlayerId = player.id;
    print('✓ Created player: ${player.firstName} ${player.lastName}');

    final fetched = await playersRepo.getById(createdPlayerId);
    print('✓ Fetched player by ID: ${fetched.id}');

    final list = await playersRepo.getList(const PlayerFilterParams(size: 1));
    print('✓ Got players list: ${list.content.length} items');

    final updated = await playersRepo.updateById(UpdatePlayerParams(
      playerId: createdPlayerId,
      firstName: 'UpdatedName',
    ));
    print('✓ Updated player name to: ${updated.firstName}');

    await playersRepo.deleteById(createdPlayerId);
    print('✓ Deleted player\n');

    // 2. Teams Flow
    print('--- TEST 2: Teams Flow ---');

    final team = await teamsRepo.createTeam(const CreateTeamParams(
      name: 'Smoke Test Team',
      playerIds: [],
    ));
    createdTeamId = team.id;
    print('✓ Created team: ${team.name}');

    await teamsRepo.getById(createdTeamId);
    print('✓ Fetched team by ID');

    await teamsRepo.getList(const TeamFilterParams(name: 'Smoke'));
    print('✓ Got filtered teams list');

    await teamsRepo.updateById(UpdateTeamParams(
      teamId: createdTeamId,
      name: 'New Team Name',
    ));
    print('✓ Updated team name');

    await teamsRepo.deleteById(createdTeamId);
    print('✓ Deleted team\n');

    // 3. Matches Full Scenario
    print('--- TEST 3: Matches Full Scenario ---');

    final matchTeam = await teamsRepo.createTeam(const CreateTeamParams(
      name: 'Match Team',
      playerIds: [],
    ));
    createdTeamId = matchTeam.id;
    print('✓ Created team for match');

    final match = await matchesRepo.createMatch(CreateMatchParams(
      teamIds: [createdTeamId],
      plannedStartTimestamp: DateTime.now().add(const Duration(days: 1)),
    ));
    createdMatchId = match.id;
    print('✓ Created match');

    await matchesRepo.startMatch(createdMatchId, DateTime.now());
    print('✓ Started match');

    await matchesRepo.endMatch(createdMatchId, DateTime.now());
    print('✓ Ended match');

    await eventsRepo.addEvent(CreateEventParams(
      matchId: createdMatchId,
      type: MatchEventType.GOAL,
      timestamp: DateTime.now(),
      teamId: createdTeamId,
      playerId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      toPlayerId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      toTeamId: createdTeamId,
    ));
    print('✓ Added event');

    final events = await eventsRepo.getEvents(createdMatchId);
    print('✓ Got events: ${events.length} items');

    await eventsRepo.deleteEvent(createdMatchId, 0);
    print('✓ Deleted event');

    final stats = await statsRepo.getStatistics(createdMatchId);
    print('✓ Got statistics: ${stats.teamStatistics.length} team stats');

    await matchesRepo.deleteById(createdMatchId);
    print('✓ Deleted match');

    await teamsRepo.deleteById(createdTeamId);
    print('✓ Deleted team\n');

    print('=== ALL TESTS PASSED ===');
  } catch (e, stack) {
    print('\n❌ TEST FAILED: $e');
    print('Stack trace:\n$stack');
  }
}
