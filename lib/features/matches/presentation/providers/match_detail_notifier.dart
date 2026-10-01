import 'dart:async';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail_state.dart';

part 'match_detail_notifier.g.dart';

@riverpod
class MatchDetailNotifier extends _$MatchDetailNotifier {
  @override
  MatchDetailState build(String id) {
    _loadMatch(id);
    return const MatchDetailInitial();
  }

  Future<void> _loadMatch(String id) async {
    state = const MatchDetailLoading();
    try {
      final repository = ref.read(matchesRepositoryProvider);
      final match = await repository.getById(id);
      state = MatchDetailLoaded(match);
    } catch (e, st) {
      log("Error while _loadMatch", error: e, stackTrace: st);
      state = MatchDetailError(e, st);
    }
  }

  Future<void> startMatch() async {
    final currentState = state;
    if (currentState is! MatchDetailLoaded) return;

    state = const MatchDetailLoading();

    try {
      final repository = ref.read(matchesRepositoryProvider);
      final updatedMatch = await repository.startMatch(id, DateTime.now());
      state = MatchDetailLoaded(updatedMatch);
    } catch (e, st) {
      log(
        "Error while startMatch",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
      state = MatchDetailError(e, st);
    }
  }

  Future<void> refresh() async {
    await _loadMatch(id);
  }
}
