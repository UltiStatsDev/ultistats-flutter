import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/logging/app_logger.dart';
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
    log(
      "Loading team $id",
      name: runtimeType.toString(),
      level: AppLogLevel.debug,
    );
    try {
      final repository = ref.read(teamsRepositoryProvider);
      final team = await repository.getById(id);

      log(
        "Loaded team $id \"${team.name}\" (players: ${team.players.length})",
        name: runtimeType.toString(),
      );
      state = TeamDetailLoaded(team);
    } catch (e, st) {
      log(
        "Error while _loadTeam",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
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

    log(
      "Setting number $number for player $playerId in team $id",
      name: runtimeType.toString(),
    );

    state = currentState.copyWith(
      processingPlayerIds: {...currentState.processingPlayerIds, playerId},
    );

    try {
      final repository = ref.read(teamsRepositoryProvider);
      await repository.addOrUpdatePlayerInTeam(id, playerId, number);
      final team = await repository.getById(id);

      log(
        "Player $playerId saved in team $id",
        name: runtimeType.toString(),
        level: AppLogLevel.debug,
      );
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

    log(
      "Removing player $playerId from team $id",
      name: runtimeType.toString(),
    );

    state = currentState.copyWith(
      processingPlayerIds: {...currentState.processingPlayerIds, playerId},
    );

    try {
      final repository = ref.read(teamsRepositoryProvider);
      await repository.removePlayerFromTeam(id, playerId);
      final team = await repository.getById(id);

      log(
        "Player $playerId removed from team $id",
        name: runtimeType.toString(),
        level: AppLogLevel.debug,
      );
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
        "Error while removePlayer",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = const TeamDetailLoading();
    await _loadTeam(id);
  }
}
