import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';
import 'package:ultistats/features/matches/domain/params/update_match_params.dart';
import 'package:ultistats/features/matches/presentation/providers/edit_match/edit_match_state.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail/match_detail_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_list/matches_list_notifier.dart';

class EditMatchNotifier extends Notifier<EditMatchState> {
  @override
  EditMatchState build() => const EditMatchInitial();

  Future<void> deleteMatch({required String id}) async {
    state = EditMatchLoading();

    try {
      final matchesRepo = ref.read(matchesRepositoryProvider);
      await matchesRepo.deleteById(id);
      ref.invalidate(matchesListProvider);
      state = EditMatchDeleted();
    } catch (e, st) {
      log(
        "Error while deleteMatch",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
      state = EditMatchError(error: e, stackTrace: st);
    }
  }

  Future<void> saveMatch({
    String? matchId,
    required List<String> teamIds,
    required int playersPerTeam,
    DateTime? plannedStartTime,
  }) async {
    state = EditMatchLoading();

    try {
      final matchesRepo = ref.read(matchesRepositoryProvider);

      if (matchId != null) {
        await matchesRepo.updateById(
          UpdateMatchParams(
            matchId: matchId,
            teamIds: teamIds,
            playersPerTeam: playersPerTeam,
            plannedStartTimestamp: plannedStartTime,
          ),
        );
      } else {
        await matchesRepo.createMatch(
          CreateMatchParams(
            teamIds: teamIds,
            playersPerTeam: playersPerTeam,
            plannedStartTimestamp: plannedStartTime,
          ),
        );
      }

      ref.invalidate(matchDetailProvider);
      ref.invalidate(matchesListProvider);
      state = EditMatchSaved();
    } catch (e, st) {
      log(
        "Error while saveMatch",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
      state = EditMatchError(error: e, stackTrace: st);
    }
  }
}

final editMatchProvider =
    NotifierProvider.autoDispose<EditMatchNotifier, EditMatchState>(
      EditMatchNotifier.new,
    );
