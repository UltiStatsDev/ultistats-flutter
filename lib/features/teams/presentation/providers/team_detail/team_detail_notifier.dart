import 'dart:async';
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/players/presentation/providers/player_detail/player_detail_notifier.dart';
import 'package:ultistats/features/teams/presentation/providers/team_detail/team_detail_state.dart';

part 'team_detail_notifier.g.dart';

@riverpod
class TeamDetailNotifier extends _$TeamDetailNotifier {
  @override
  TeamDetailState build(String id) {
    _loadTeam(id);
    return const TeamDetailLoading();
  }

  Future<void> _loadTeam(String id) async {
    try {
      final repository = ref.read(teamsRepositoryProvider);
      final team = await repository.getById(id);

      state = TeamDetailLoaded(team);
    } catch (e, st) {
      state = TeamDetailError(e, st);
    }
  }

  Future<void> updatePlayer(
    String playerId,
    int number, [
    Completer? completer,
  ]) async {
    final currentState = state;
    if (currentState is! TeamDetailLoaded) return;

    state = currentState.copyWith(
      processingPlayerIds: {...currentState.processingPlayerIds, playerId},
    );

    try {
      final repository = ref.read(teamsRepositoryProvider);
      await repository.addOrUpdatePlayerInTeam(id, playerId, number);
      final team = await repository.getById(id);

      if (state is TeamDetailLoaded) {
        state = TeamDetailLoaded(
          team,
          processingPlayerIds: (state as TeamDetailLoaded).processingPlayerIds
              .where((i) => i != playerId)
              .toSet(),
        );
      }
      ref.invalidate(playerDetailProvider(playerId));
      completer?.complete();
    } catch (e, st) {
      if (state is TeamDetailLoaded) {
        state = (state as TeamDetailLoaded).copyWith(
          processingPlayerIds: (state as TeamDetailLoaded).processingPlayerIds
              .where((i) => i != playerId)
              .toSet(),
        );
      }
      completer?.completeError(e, st);
      log(
        "Error while addPlayer",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
    }
  }

  Future<void> removePlayer(String playerId, [Completer? completer]) async {
    final currentState = state;
    if (currentState is! TeamDetailLoaded) return;

    state = currentState.copyWith(
      processingPlayerIds: {...currentState.processingPlayerIds, playerId},
    );

    try {
      final repository = ref.read(teamsRepositoryProvider);
      await repository.removePlayerFromTeam(id, playerId);
      final team = await repository.getById(id);

      if (state is TeamDetailLoaded) {
        state = TeamDetailLoaded(
          team,
          processingPlayerIds: (state as TeamDetailLoaded).processingPlayerIds
              .where((i) => i != playerId)
              .toSet(),
        );
      }
      ref.invalidate(playerDetailProvider(playerId));
      completer?.complete();
    } catch (e, st) {
      if (state is TeamDetailLoaded) {
        state = (state as TeamDetailLoaded).copyWith(
          processingPlayerIds: (state as TeamDetailLoaded).processingPlayerIds
              .where((i) => i != playerId)
              .toSet(),
        );
      }
      completer?.completeError(e, st);
    }
  }

  Future<void> refresh() async {
    state = const TeamDetailLoading();
    await _loadTeam(id);
  }
}
