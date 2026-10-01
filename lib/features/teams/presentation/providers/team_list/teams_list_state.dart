import 'package:ultistats/features/teams/domain/entities/team_list_item.dart';

sealed class TeamsListState {
  const TeamsListState();
}

class TeamsListLoading extends TeamsListState {
  const TeamsListLoading();
}

class TeamsListError extends TeamsListState {
  final Object exception;
  final StackTrace stackTrace;

  const TeamsListError(this.exception, this.stackTrace);
}

class TeamsListLoaded extends TeamsListState {
  final List<TeamListItem> teams;
  final bool isLoadingMore;
  final bool isRefreshing;
  final bool hasReachedEnd;
  final int currentPage;
  final int totalPages;

  const TeamsListLoaded({
    required this.teams,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.hasReachedEnd = false,
    this.currentPage = 0,
    this.totalPages = 0,
  });

  TeamsListLoaded copyWith({
    List<TeamListItem>? teams,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? hasReachedEnd,
    int? currentPage,
    int? totalPages,
  }) {
    return TeamsListLoaded(
      teams: teams ?? this.teams,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
