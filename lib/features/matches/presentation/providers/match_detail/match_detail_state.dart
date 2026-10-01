import 'package:ultistats/features/matches/domain/entities/match_detail.dart';

sealed class MatchDetailState {
  const MatchDetailState();
}

class MatchDetailInitial extends MatchDetailState {
  const MatchDetailInitial();
}

class MatchDetailLoading extends MatchDetailState {
  const MatchDetailLoading();
}

class MatchDetailLoaded extends MatchDetailState {
  final MatchDetail match;

  const MatchDetailLoaded(this.match);

  MatchDetailLoaded copyWith({MatchDetail? match, bool? isStarting}) {
    return MatchDetailLoaded(
      match ?? this.match,
    );
  }
}

class MatchDetailError extends MatchDetailState {
  final Object exception;
  final StackTrace stackTrace;

  const MatchDetailError(this.exception, this.stackTrace);
}
