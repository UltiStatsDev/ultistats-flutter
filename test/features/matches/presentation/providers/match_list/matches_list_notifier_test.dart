import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_list_item.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';
import 'package:ultistats/features/matches/domain/params/update_match_params.dart';
import 'package:ultistats/features/matches/domain/repositories/matches_repository.dart';
import 'package:ultistats/features/matches/presentation/providers/match_list/matches_list_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_list/matches_list_state.dart';

class FakeMatchesRepository implements MatchesRepository {
  FakeMatchesRepository({this.getListResult, this.getListError});

  Future<Page<MatchListItem>>? getListResult;
  Object? getListError;

  final List<MatchFilterParams> getListCalls = [];

  @override
  Future<Page<MatchListItem>> getList(MatchFilterParams params) async {
    getListCalls.add(params);
    if (getListError != null) {
      throw getListError!;
    }
    final page = await getListResult!;
    return page;
  }

  @override
  Future<void> createMatch(CreateMatchParams params) async {}

  @override
  Future<MatchDetail> getById(String matchId) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateById(UpdateMatchParams params) async {}

  @override
  Future<void> deleteById(String matchId) async {}

  @override
  Future<MatchDetail> startMatch(String matchId, DateTime date) async {
    throw UnimplementedError();
  }

  @override
  Future<MatchDetail> endMatch(String matchId, DateTime date) async {
    throw UnimplementedError();
  }
}

void main() {
  late FakeMatchesRepository repository;

  setUp(() {
    repository = FakeMatchesRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        matchesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('MatchesListNotifier', () {
    test('initial load emits loaded state with mapped matches', () async {
      repository.getListResult = Future.value(
        Page(
          content: [
            MatchListItem(
              id: 'match-1',
              teams: [
                MatchListTeam(
                  teamId: 'team-1',
                  teamName: 'Team One',
                  teamScore: 0,
                ),
              ],
              status: MatchStatus.planned,
            ),
          ],
          totalElements: 1,
          totalPages: 1,
          currentPage: 0,
          size: 20,
        ),
      );

      final container = createContainer();
      final notifier = container.read(matchesListProvider.notifier);
      await notifier.loadInitial();

      final state = container.read(matchesListProvider);
      expect(state, isA<MatchesListLoaded>());

      final loaded = state as MatchesListLoaded;
      expect(loaded.matches.length, 1);
      expect(loaded.matches.first.id, 'match-1');
      expect(loaded.matches.first.status, MatchStatus.planned);
      expect(loaded.hasReachedEnd, isTrue);
      expect(repository.getListCalls.first.page, 0);
      expect(repository.getListCalls.first.size, 20);
    });

    test('emits error state when loading fails', () async {
      repository.getListError = Exception('Network error');

      final container = createContainer();
      final notifier = container.read(matchesListProvider.notifier);
      await notifier.loadInitial();

      final state = container.read(matchesListProvider);
      expect(state, isA<MatchesListError>());
    });
  });
}
