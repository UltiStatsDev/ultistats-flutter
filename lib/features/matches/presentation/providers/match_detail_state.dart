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
  final bool isStarting;

  const MatchDetailLoaded(this.match, {this.isStarting = false});

  MatchDetailLoaded copyWith({MatchDetail? match, bool? isStarting}) {
    return MatchDetailLoaded(
      match ?? this.match,
      isStarting: isStarting ?? this.isStarting,
    );
  }
}

class MatchDetailError extends MatchDetailState {
  final Object exception;
  final StackTrace stackTrace;

  const MatchDetailError(this.exception, this.stackTrace);
}
