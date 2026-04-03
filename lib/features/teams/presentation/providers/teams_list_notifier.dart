import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/teams/domain/params/team_filter_params.dart';
import 'package:ultistats/features/teams/presentation/providers/teams_list_state.dart';

class TeamsListNotifier extends Notifier<TeamsListState> {
  static const int _pageSize = 20;
  static const double _scrollThreshold = 200.0;

  @override
  TeamsListState build() {
    loadInitial();
    return const TeamsListLoading();
  }

  Future<TeamsListLoaded> _fetchPage(int page) async {
    final repository = ref.read(teamsRepositoryProvider);
    final result = await repository.getList(
      TeamFilterParams(page: page, size: _pageSize),
    );

    return TeamsListLoaded(
      teams: result.content,
      currentPage: result.currentPage,
      totalPages: result.totalPages,
      hasReachedEnd: result.currentPage >= result.totalPages - 1,
    );
  }

  Future<void> loadInitial() async {
    state = const TeamsListLoading();
    try {
      state = await _fetchPage(0);
    } catch (e, st) {
      state = TeamsListError(e, st);
    }
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is TeamsListLoaded && currentState.isRefreshing) return;

    if (currentState is TeamsListLoaded) {
      state = currentState.copyWith(isRefreshing: true);
    }

    try {
      state = await _fetchPage(0);
    } catch (e, st) {
      if (currentState is TeamsListLoaded) {
        state = currentState.copyWith(isRefreshing: false);
      } else {
        state = TeamsListError(e, st);
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
    if (currentState is! TeamsListLoaded) return;
    if (currentState.isLoadingMore || currentState.hasReachedEnd) return;

    state = currentState.copyWith(isLoadingMore: true);

    try {
      final nextPage = await _fetchPage(currentState.currentPage + 1);

      state = currentState.copyWith(
        teams: [...currentState.teams, ...nextPage.teams],
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
