import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';
import 'package:ultistats/features/matches/domain/params/update_match_params.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_list_notifier.dart';

class EditMatchState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const EditMatchState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  EditMatchState copyWith({bool? isLoading, String? error, bool? isSuccess}) {
    return EditMatchState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class EditMatchNotifier extends Notifier<EditMatchState> {
  @override
  EditMatchState build() => const EditMatchState();

  Future<void> saveMatch({
    String? matchId,
    required List<String> teamIds,
    DateTime? plannedStartTime,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      final matchesRepo = ref.read(matchesRepositoryProvider);

      if (matchId != null) {
        await matchesRepo.updateById(
          UpdateMatchParams(
            matchId: matchId,
            teamIds: teamIds,
            plannedStartTimestamp: plannedStartTime,
          ),
        );
      } else {
        await matchesRepo.createMatch(
          CreateMatchParams(
            teamIds: teamIds,
            plannedStartTimestamp: plannedStartTime,
          ),
        );
      }

      ref.invalidate(matchDetailProvider);
      ref.invalidate(matchesListProvider);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e, st) {
      log(
        "Error while saveMatch",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
      state = state.copyWith(
        isLoading: false,
        error: kDebugMode ? e.toString() : "Ошибка сохранения матча",
      );
    }
  }
}

final editMatchProvider =
    NotifierProvider.autoDispose<EditMatchNotifier, EditMatchState>(
      EditMatchNotifier.new,
    );
