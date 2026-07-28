import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/features/players/data/models/create_player_request.dart';
import 'package:ultistats/features/players/data/models/player_filter_request.dart';
import 'package:ultistats/features/players/data/models/update_player_request.dart';
import 'package:ultistats/features/players/data/sources/players_api.dart';

void main() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://158.160.219.91/api/v1',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  final playersApi = PlayersApi(dio);

  group('PlayersApi Integration Tests', () {
    String? createdPlayerId;

    test('Create player', () async {
      final request = const CreatePlayerRequest(
        firstName: 'Test',
        lastName: 'Player',
      );

      final response = await playersApi.createPlayer(request);

      expect(response.id, isNotNull);
      expect(response.firstName, 'Test');
      expect(response.lastName, 'Player');
      createdPlayerId = response.id;
    });

    test('Get player by id', () async {
      expect(createdPlayerId, isNotNull);

      final response = await playersApi.getPlayerById(createdPlayerId!);

      expect(response.id, createdPlayerId);
      expect(response.firstName, 'Test');
    });

    test('Update player', () async {
      expect(createdPlayerId, isNotNull);

      final request = const UpdatePlayerRequest(
        firstName: 'UpdatedName',
      );

      final response = await playersApi.updatePlayer(createdPlayerId!, request);

      expect(response.firstName, 'UpdatedName');
    });

    test('Get players list with pagination and filter', () async {
      final request = const PlayerFilterRequest(
        page: 0,
        size: 10,
        name: 'UpdatedName',
      );

      final response = await playersApi.getPlayers(request);

      expect(response.content, isNotEmpty);
      expect(response.content.any((p) => p.id == createdPlayerId), true);
    });

    test('Delete player', () async {
      expect(createdPlayerId, isNotNull);

      await playersApi.deletePlayer(createdPlayerId!);

      // Verify deletion by trying to fetch it (expecting 404)
      try {
        await playersApi.getPlayerById(createdPlayerId!);
        fail('Should have thrown a 404 error');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 404);
      }
    });
  });
}
