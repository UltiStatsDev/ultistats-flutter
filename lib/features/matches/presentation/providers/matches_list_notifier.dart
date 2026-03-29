import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_list_state.dart';

class MatchesListNotifier extends Notifier<MatchesListState> {
  static const int _pageSize = 20;

  @override
  MatchesListState build() {
    loadInitial();
    return const MatchesListLoading();
  }

  Future<MatchesListLoaded> _fetchPage(int page) async {
    final repository = ref.read(matchesRepositoryProvider);
    final result = await repository.getList(
      MatchFilterParams(page: page, size: _pageSize),
    );

    return MatchesListLoaded(
      matches: result.content,
      currentPage: result.currentPage,
      totalPages: result.totalPages,
      hasReachedEnd: result.currentPage >= result.totalPages - 1,
    );
  }

  Future<void> loadInitial() async {
    state = const MatchesListLoading();
    try {
      state = await _fetchPage(0);
    } catch (e, st) {
      state = MatchesListError(e, st);
    }
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is MatchesListLoaded && currentState.isRefreshing) return;

    if (currentState is MatchesListLoaded) {
      state = currentState.copyWith(isRefreshing: true);
    }

    try {
      state = await _fetchPage(0);
    } catch (e, st) {
      if (currentState is MatchesListLoaded) {
        state = currentState.copyWith(isRefreshing: false);
      } else {
        state = MatchesListError(e, st);
      }
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! MatchesListLoaded) return;
    if (currentState.isLoadingMore || currentState.hasReachedEnd) return;

    state = currentState.copyWith(isLoadingMore: true);

    try {
      final nextPage = await _fetchPage(currentState.currentPage + 1);

      state = currentState.copyWith(
        matches: [...currentState.matches, ...nextPage.matches],
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
