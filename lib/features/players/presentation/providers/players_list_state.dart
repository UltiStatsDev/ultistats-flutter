import 'package:ultistats/features/players/domain/entities/player.dart';

sealed class PlayersListState {
  const PlayersListState();
}

class PlayersListLoading extends PlayersListState {
  const PlayersListLoading();
}

class PlayersListError extends PlayersListState {
  final Object exception;
  final StackTrace stackTrace;

  const PlayersListError(this.exception, this.stackTrace);
}

class PlayersListLoaded extends PlayersListState {
  final List<Player> players;
  final bool isLoadingMore;
  final bool isRefreshing;
  final bool hasReachedEnd;
  final int currentPage;
  final int totalPages;

  const PlayersListLoaded({
    required this.players,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.hasReachedEnd = false,
    this.currentPage = 0,
    this.totalPages = 0,
  });

  PlayersListLoaded copyWith({
    List<Player>? players,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool? hasReachedEnd,
    int? currentPage,
    int? totalPages,
  }) {
    return PlayersListLoaded(
      players: players ?? this.players,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
