import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/players/domain/entities/player_detail.dart';
import 'package:ultistats/features/players/domain/entities/player_list_item.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';
import 'package:ultistats/features/players/domain/repositories/players_repository.dart';
import 'package:ultistats/features/players/presentation/providers/player_list/players_list_notifier.dart';
import 'package:ultistats/features/players/presentation/providers/player_list/players_list_state.dart';

class FakePlayersRepository implements PlayersRepository {
  FakePlayersRepository({this.getListResult, this.getListError});

  Future<Page<PlayerListItem>>? getListResult;
  Object? getListError;

  final List<PlayerFilterParams> getListCalls = [];

  @override
  Future<Page<PlayerListItem>> getList(PlayerFilterParams params) async {
    getListCalls.add(params);
    if (getListError != null) {
      throw getListError!;
    }
    final page = await getListResult!;
    return page;
  }

  @override
  Future<PlayerDetail> getById(String playerId) async {
    throw UnimplementedError();
  }

  @override
  Future<PlayerDetail> updateById(UpdatePlayerParams params) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteById(String playerId) async {}

  @override
  Future<PlayerDetail> createPlayer(CreatePlayerParams params) async {
    throw UnimplementedError();
  }

  @override
  Future<String?> getPlayerPhotoUrl(String playerId) async => null;

  @override
  Future<String?> uploadPlayerPhoto(
    String playerId,
    List<int> bytes,
    String filename,
  ) async {
    return null;
  }

  @override
  Future<void> deletePlayerPhoto(String playerId) async {}
}

void main() {
  late FakePlayersRepository repository;

  setUp(() {
    repository = FakePlayersRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        playersRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('PlayersListNotifier', () {
    test('initial load emits loaded state with mapped players', () async {
      repository.getListResult = Future.value(
        Page(
          content: [
            PlayerListItem(
              id: 'player-1',
              firstName: 'Ivan',
              lastName: 'Ivanov',
            ),
          ],
          totalElements: 1,
          totalPages: 1,
          currentPage: 0,
          size: 20,
        ),
      );

      final container = createContainer();
      final notifier = container.read(playersListProvider.notifier);
      await notifier.loadInitial();

      final state = container.read(playersListProvider);
      expect(state, isA<PlayersListLoaded>());

      final loaded = state as PlayersListLoaded;
      expect(loaded.players.length, 1);
      expect(loaded.players.first.id, 'player-1');
      expect(loaded.players.first.firstName, 'Ivan');
      expect(loaded.players.first.lastName, 'Ivanov');
      expect(loaded.hasReachedEnd, isTrue);
      expect(repository.getListCalls.first.page, 0);
      expect(repository.getListCalls.first.size, 20);
    });

    test('emits error state when loading fails', () async {
      repository.getListError = Exception('Network error');

      final container = createContainer();
      final notifier = container.read(playersListProvider.notifier);
      await notifier.loadInitial();

      final state = container.read(playersListProvider);
      expect(state, isA<PlayersListError>());
    });
  });
}
