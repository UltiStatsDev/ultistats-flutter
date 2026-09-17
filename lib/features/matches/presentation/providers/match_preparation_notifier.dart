import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_preparation_state.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_list_notifier.dart';

part 'match_preparation_notifier.g.dart';

@riverpod
class MatchPreparationNotifier extends _$MatchPreparationNotifier {
  @override
  MatchPreparationState build(String matchId) {
    _loadData(matchId);
    return const MatchPreparationLoading();
  }

  Future<void> _loadData(String matchId) async {
    try {
      final matchesRepo = ref.read(matchesRepositoryProvider);
      final teamsRepo = ref.read(teamsRepositoryProvider);

      final match = await matchesRepo.getById(matchId);

      final team1 = await teamsRepo.getById(match.teams[0].id);
      final team2 = await teamsRepo.getById(match.teams[1].id);

      state = MatchPreparationLoaded(
        match: match,
        team1: team1,
        team2: team2,
        selectedPlayerIds1: team1.players.take(5).map((p) => p.playerId).toSet(),
        selectedPlayerIds2: team2.players.take(5).map((p) => p.playerId).toSet(),
      );
    } catch (e, st) {
      state = MatchPreparationError(e, st);
    }
  }

  void togglePlayer(String teamId, String playerId) {
    final currentState = state;
    if (currentState is! MatchPreparationLoaded) return;

    if (teamId == currentState.team1.id) {
      final selected = Set<String>.from(currentState.selectedPlayerIds1);
      if (selected.contains(playerId)) {
        selected.remove(playerId);
      } else {
        if (selected.length < 5) {
          selected.add(playerId);
        }
      }
      state = currentState.copyWith(selectedPlayerIds1: selected);
    } else if (teamId == currentState.team2.id) {
      final selected = Set<String>.from(currentState.selectedPlayerIds2);
      if (selected.contains(playerId)) {
        selected.remove(playerId);
      } else {
        if (selected.length < 5) {
          selected.add(playerId);
        }
      }
      state = currentState.copyWith(selectedPlayerIds2: selected);
    }
  }

  Future<void> startMatch() async {
    final currentState = state;
    if (currentState is! MatchPreparationLoaded || !currentState.canStart) {
      return;
    }

    state = currentState.copyWith(isStarting: true);

    try {
      final repository = ref.read(matchesRepositoryProvider);

      await repository.startMatch(matchId, DateTime.now());

      ref.invalidate(matchesListProvider);
      ref.invalidate(matchDetailProvider(matchId));

      state = currentState.copyWith(isStarting: false, isSuccess: true);
    } catch (e, st) {
      state = MatchPreparationError(e, st);
    }
  }
}
