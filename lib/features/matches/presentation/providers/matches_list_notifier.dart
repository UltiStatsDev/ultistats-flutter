import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_list_state.dart';

class MatchesListNotifier extends Notifier<MatchesListState> {
  static const int _pageSize = 20;
  static const double _scrollThreshold = 200.0;

  String _searchQuery = '';
  Timer? _debounceTimer;

  @override
  MatchesListState build() {
    loadInitial();
    return const MatchesListLoading();
  }

  Future<MatchesListLoaded> _fetchPage(int page) async {
    final repository = ref.read(matchesRepositoryProvider);
    final result = await repository.getList(
      MatchFilterParams(
        page: page,
        size: _pageSize,
        /// TODO В будущем здесь можно добавить фильтр по названию команд
      ),
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
      log(
        "Error while loadInitial",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
      state = MatchesListError(e, st);
    }
  }

  void onSearchChanged(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    final currentState = state;
    if (currentState is MatchesListLoaded) {
      state = currentState.copyWith(isRefreshing: true);
    } else if (currentState is! MatchesListLoading) {
      state = const MatchesListLoading();
    }

    try {
      final newState = await _fetchPage(0);
      state = newState;
    } catch (e, st) {
      log(
        "Error while _performSearch",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
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
      log(
        "Error while refresh",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
      if (currentState is MatchesListLoaded) {
        state = currentState.copyWith(isRefreshing: false);
      } else {
        state = MatchesListError(e, st);
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
    } catch (e, st) {
      log(
        "Error while _loadMore",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
      state = currentState.copyWith(isLoadingMore: false);
    }
  }
}

final matchesListProvider =
    NotifierProvider<MatchesListNotifier, MatchesListState>(
      MatchesListNotifier.new,
    );
