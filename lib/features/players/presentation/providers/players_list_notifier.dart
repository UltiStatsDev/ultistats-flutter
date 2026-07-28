import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';
import 'package:ultistats/features/players/presentation/providers/players_list_state.dart';

class PlayersListNotifier extends Notifier<PlayersListState> {
  static const int _pageSize = 20;
  static const double _scrollThreshold = 200.0;

  @override
  PlayersListState build() {
    loadInitial();
    return const PlayersListLoading();
  }

  Future<PlayersListLoaded> _fetchPage(int page) async {
    final repository = ref.read(playersRepositoryProvider);
    final result = await repository.getList(
      PlayerFilterParams(page: page, size: _pageSize),
    );

    return PlayersListLoaded(
      players: result.content,
      currentPage: result.currentPage,
      totalPages: result.totalPages,
      hasReachedEnd: result.currentPage >= result.totalPages - 1,
    );
  }

  Future<void> loadInitial() async {
    state = const PlayersListLoading();
    try {
      state = await _fetchPage(0);
    } catch (e, st) {
      state = PlayersListError(e, st);
    }
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is PlayersListLoaded && currentState.isRefreshing) return;

    if (currentState is PlayersListLoaded) {
      state = currentState.copyWith(isRefreshing: true);
    }

    try {
      state = await _fetchPage(0);
    } catch (e, st) {
      if (currentState is PlayersListLoaded) {
        state = currentState.copyWith(isRefreshing: false);
      } else {
        state = PlayersListError(e, st);
      }
    }
  }

  void onScrollUpdate(double offset, double maxScrollExtent) {
    if (offset >= (maxScrollExtent - _scrollThreshold)) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final currentState = state;
    if (currentState is! PlayersListLoaded) return;
    if (currentState.isLoadingMore || currentState.hasReachedEnd) return;

    state = currentState.copyWith(isLoadingMore: true);

    try {
      final nextPage = await _fetchPage(currentState.currentPage + 1);

      state = currentState.copyWith(
        players: [...currentState.players, ...nextPage.players],
        isLoadingMore: false,
        currentPage: nextPage.currentPage,
        totalPages: nextPage.totalPages,
        hasReachedEnd: nextPage.hasReachedEnd,
      );
    } catch (e) {
      state = currentState.copyWith(isLoadingMore: false);
    }
  }
}

final playersListProvider =
NotifierProvider<PlayersListNotifier, PlayersListState>(
  PlayersListNotifier.new,
);

