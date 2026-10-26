import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/data/models/page_model.dart';
import 'package:ultistats/core/data/models/photo_url_response.dart';
import 'package:ultistats/features/players/data/models/player_detail_model.dart';
import 'package:ultistats/features/players/data/models/player_list_item_model.dart';
import 'package:ultistats/features/players/data/models/player_membership_model.dart';
import 'package:ultistats/features/players/data/repositories/players_repository_impl.dart';
import 'package:ultistats/features/players/data/requests/create_player_request.dart';
import 'package:ultistats/features/players/data/requests/player_filter_request.dart';
import 'package:ultistats/features/players/data/requests/update_player_request.dart';
import 'package:ultistats/features/players/data/sources/players_api.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';

class FakePlayersApi implements PlayersApi {
  FakePlayersApi({
    this.playersPage,
    this.createdPlayer,
    this.playerDetail,
    this.updatedPlayer,
    this.playerPhotoUrl,
  });

  Future<PageModel<PlayerListItemModel>>? playersPage;
  Future<PlayerDetailModel>? createdPlayer;
  Future<PlayerDetailModel>? playerDetail;
  Future<PlayerDetailModel>? updatedPlayer;
  String? playerPhotoUrl;

  CreatePlayerRequest? lastCreateBody;
  UpdatePlayerRequest? lastUpdateBody;

  int deletePlayerCallCount = 0;
  int deletePlayerPhotoCallCount = 0;

  @override
  Future<PageModel<PlayerListItemModel>> getPlayers(
    PlayerFilterRequest queries,
  ) {
    return playersPage!;
  }

  @override
  Future<PlayerDetailModel> createPlayer(CreatePlayerRequest body) {
    lastCreateBody = body;
    return createdPlayer!;
  }

  @override
  Future<PlayerDetailModel> getPlayerById(String id) {
    return playerDetail!;
  }

  @override
  Future<PlayerDetailModel> updatePlayer(
    String id,
    UpdatePlayerRequest body,
  ) {
    lastUpdateBody = body;
    return updatedPlayer!;
  }

  @override
  Future<void> deletePlayer(String id) async {
    deletePlayerCallCount++;
  }

  @override
  Future<List<PlayerMembershipModel>> getPlayerTeams(String playerId) async {
    return const [];
  }

  @override
  Future<PhotoUrlResponse> getPlayerPhotoUrl(String playerId) {
    return Future.value(PhotoUrlResponse(url: playerPhotoUrl));
  }

  @override
  Future<PhotoUrlResponse> uploadPlayerPhoto(
    String playerId,
    MultipartFile multipartFile,
  ) {
    return Future.value(PhotoUrlResponse(url: playerPhotoUrl));
  }

  @override
  Future<PhotoUrlResponse> deletePlayerPhoto(String playerId) async {
    deletePlayerPhotoCallCount++;
    return PhotoUrlResponse(url: playerPhotoUrl);
  }
}

void main() {
  late FakePlayersApi api;
  late PlayersRepositoryImpl repository;

  setUp(() {
    api = FakePlayersApi();
    repository = PlayersRepositoryImpl(api);
  });

  group('PlayersRepositoryImpl', () {
    group('getList', () {
      test('maps api page to domain entities and keeps pagination', () async {
        api.playersPage = Future.value(
          PageModel<PlayerListItemModel>(
            content: [
              PlayerListItemModel(
                id: 'player-1',
                firstName: 'Ivan',
                lastName: 'Ivanov',
                photoUrl: 'https://example.com/photo-1',
              ),
              PlayerListItemModel(
                id: 'player-2',
                firstName: 'Petr',
                lastName: 'Petrov',
                photoUrl: null,
              ),
            ],
            totalElements: 2,
            totalPages: 1,
            currentPage: 0,
            size: 20,
          ),
        );

        final result = await repository.getList(
          const PlayerFilterParams(page: 0, size: 20),
        );

        expect(result.content.length, 2);
        expect(result.content.first.id, 'player-1');
        expect(result.content.first.firstName, 'Ivan');
        expect(result.content.first.lastName, 'Ivanov');
        expect(result.content.first.photoUrl, 'https://example.com/photo-1');
        expect(result.content[1].id, 'player-2');
        expect(result.content[1].firstName, 'Petr');
        expect(result.content[1].photoUrl, isNull);

        expect(result.totalElements, 2);
        expect(result.totalPages, 1);
        expect(result.currentPage, 0);
        expect(result.size, 20);
      });
    });

    group('getById', () {
      test('maps player detail with memberships to entity', () async {
        api.playerDetail = Future.value(
          PlayerDetailModel(
            id: 'player-1',
            firstName: 'Ivan',
            lastName: 'Ivanov',
            photoUrl: 'https://example.com/photo-1',
            memberships: [
              PlayerMembershipModel(
                teamId: 'team-1',
                teamName: 'Team One',
                playerId: 'player-1',
                number: 7,
              ),
            ],
          ),
        );

        final result = await repository.getById('player-1');

        expect(result.id, 'player-1');
        expect(result.firstName, 'Ivan');
        expect(result.lastName, 'Ivanov');
        expect(result.photoUrl, 'https://example.com/photo-1');
        expect(result.memberships.length, 1);
        expect(result.memberships.first.teamId, 'team-1');
        expect(result.memberships.first.teamName, 'Team One');
        expect(result.memberships.first.playerId, 'player-1');
        expect(result.memberships.first.number, 7);
      });
    });

    group('createPlayer', () {
      test('creates player and returns mapped detail', () async {
        api.createdPlayer = Future.value(
          PlayerDetailModel(
            id: 'player-9',
            firstName: 'New',
            lastName: 'Player',
            memberships: const [],
          ),
        );

        final result = await repository.createPlayer(
          const CreatePlayerParams(firstName: 'New', lastName: 'Player'),
        );

        expect(api.lastCreateBody?.firstName, 'New');
        expect(api.lastCreateBody?.lastName, 'Player');
        expect(result.id, 'player-9');
        expect(result.firstName, 'New');
      });
    });

    group('updateById', () {
      test('maps update params to request', () async {
        api.updatedPlayer = Future.value(
          PlayerDetailModel(
            id: 'player-1',
            firstName: 'Ivan',
            lastName: 'Ivanov',
            memberships: const [],
          ),
        );

        final result = await repository.updateById(
          const UpdatePlayerParams(playerId: 'player-1', firstName: 'Ivan'),
        );

        expect(api.lastUpdateBody?.firstName, 'Ivan');
        expect(api.lastUpdateBody?.lastName, isNull);
        expect(result.id, 'player-1');
      });
    });

    group('deletePlayer', () {
      test('delegates deletion to api', () async {
        await repository.deleteById('player-1');

        expect(api.deletePlayerCallCount, 1);
      });
    });

    group('player photo', () {
      test('getPlayerPhotoUrl returns url', () async {
        api.playerPhotoUrl = 'https://example.com/photo';

        final url = await repository.getPlayerPhotoUrl('player-1');

        expect(url, 'https://example.com/photo');
      });

      test('uploadPlayerPhoto returns url', () async {
        api.playerPhotoUrl = 'https://example.com/photo';

        final url = await repository.uploadPlayerPhoto(
          'player-1',
          [1, 2, 3],
          'photo.jpg',
        );

        expect(url, 'https://example.com/photo');
      });

      test('deletePlayerPhoto delegates to api', () async {
        api.playerPhotoUrl = 'https://example.com/photo';

        await repository.deletePlayerPhoto('player-1');

        expect(api.deletePlayerPhotoCallCount, 1);
      });
    });
  });
}
