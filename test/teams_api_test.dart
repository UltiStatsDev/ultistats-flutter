import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/features/teams/data/models/create_team_request.dart';
import 'package:ultistats/features/teams/data/models/team_filter_request.dart';
import 'package:ultistats/features/teams/data/models/update_team_request.dart';
import 'package:ultistats/features/teams/data/models/upsert_team_player_request.dart';
import 'package:ultistats/features/teams/data/sources/teams_api.dart';
import 'package:ultistats/features/players/data/sources/players_api.dart';
import 'package:ultistats/features/players/data/models/create_player_request.dart';

void main() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://158.160.219.91/api/v1',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  final teamsApi = TeamsApi(dio);
  final playersApi = PlayersApi(dio);

  group('TeamsApi Integration Tests', () {
    String? createdTeamId;
    String? createdPlayerId;

    test('Create team', () async {
      final request = const CreateTeamRequest(
        name: 'UltiStats Team',
        city: 'Moscow',
      );

      final response = await teamsApi.createTeam(request);

      expect(response.id, isNotNull);
      expect(response.name, 'UltiStats Team');
      expect(response.city, 'Moscow');
      createdTeamId = response.id;
    });

    test('Get team by id', () async {
      expect(createdTeamId, isNotNull);

      final response = await teamsApi.getTeamById(createdTeamId!);

      expect(response.id, createdTeamId);
      expect(response.name, 'UltiStats Team');
    });

    test('Update team', () async {
      expect(createdTeamId, isNotNull);

      final request = const UpdateTeamRequest(
        name: 'UltiStats Pro',
        city: 'St. Petersburg',
      );

      final response = await teamsApi.updateTeam(createdTeamId!, request);

      expect(response.name, 'UltiStats Pro');
      expect(response.city, 'St. Petersburg');
    });

    test('Get teams list', () async {
      final request = const TeamFilterRequest(
        page: 0,
        size: 10,
        name: 'UltiStats',
      );

      final response = await teamsApi.getTeams(request);

      expect(response.content, isNotEmpty);
      expect(response.content.any((t) => t.id == createdTeamId), true);
    });

    test('Roster management: add, get and remove player', () async {
      expect(createdTeamId, isNotNull);

      // 1. Создаем игрока для теста
      final playerRes = await playersApi.createPlayer(
        const CreatePlayerRequest(firstName: 'Team', lastName: 'Member'),
      );
      createdPlayerId = playerRes.id;

      // 2. Добавляем игрока в команду (PUT /teams/{id}/players/{playerId})
      final membership = await teamsApi.addOrUpdatePlayerInTeam(
        createdTeamId!,
        createdPlayerId!,
        const UpsertTeamPlayerRequest(number: 77),
      );

      expect(membership.playerId, createdPlayerId);
      expect(membership.number, 77);

      // 3. Проверяем состав команды
      final roster = await teamsApi.getTeamRoster(createdTeamId!);
      expect(roster.any((m) => m.playerId == createdPlayerId), true);

      // 4. Удаляем игрока из команды
      await teamsApi.removePlayerFromTeam(createdTeamId!, createdPlayerId!);
      
      final updatedRoster = await teamsApi.getTeamRoster(createdTeamId!);
      expect(updatedRoster.any((m) => m.playerId == createdPlayerId), false);
    });

    test('Cleanup: Delete team and player', () async {
      if (createdTeamId != null) {
        await teamsApi.deleteTeam(createdTeamId!);
      }
      if (createdPlayerId != null) {
        await playersApi.deletePlayer(createdPlayerId!);
      }

      // Проверка удаления команды
      if (createdTeamId != null) {
        try {
          await teamsApi.getTeamById(createdTeamId!);
          fail('Team should be deleted');
        } on DioException catch (e) {
          expect(e.response?.statusCode, 404);
        }
      }
    });
  });
}
