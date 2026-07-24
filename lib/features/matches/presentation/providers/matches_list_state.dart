import 'package:ultistats/features/matches/domain/entities/match_list_item.dart';

sealed class MatchesListState {
  const MatchesListState();
}

class MatchesListLoading extends MatchesListState {
  const MatchesListLoading();
}

class MatchesListError extends MatchesListState {
  final Object exception;
  final StackTrace stackTrace;

  const MatchesListError(this.exception, this.stackTrace);
}

class MatchesListLoaded extends MatchesListState {
  final List<MatchListItem> matches;
  final bool isLoadingMore;
  final bool isRefreshing;
  final bool hasReachedEnd;
  final int currentPage;
  final int totalPages;

  const MatchesListLoaded({
    required this.matches,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.hasReachedEnd = false,
    this.currentPage = 0,
    this.totalPages = 0,
  });

  MatchesListLoaded copyWith({
    List<MatchListItem>? matches,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? hasReachedEnd,
    int? currentPage,
    int? totalPages,
  }) {
    return MatchesListLoaded(
      matches: matches ?? this.matches,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
