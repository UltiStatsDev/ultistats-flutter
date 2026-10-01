import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/teams/domain/params/create_team_params.dart';
import 'package:ultistats/features/teams/domain/params/update_team_params.dart';
import 'package:ultistats/features/teams/presentation/providers/team_detail/team_detail_notifier.dart';
import 'package:ultistats/features/teams/presentation/providers/team_list/teams_list_notifier.dart';

class EditTeamState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const EditTeamState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  EditTeamState copyWith({bool? isLoading, String? error, bool? isSuccess}) {
    return EditTeamState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class EditTeamNotifier extends Notifier<EditTeamState> {
  @override
  EditTeamState build() => const EditTeamState();

  Future<void> deletePhoto(String id) async {
    try {
      final teamsRepo = ref.read(teamsRepositoryProvider);
      await teamsRepo.deleteTeamPhoto(id);
      ref.invalidate(teamsListProvider);
      ref.invalidate(teamDetailProvider);
    } catch (e, st) {
      log(
        "Error while deleting team photo",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
    }
  }

  Future<void> saveTeam({
    String? teamId,
    required String name,
    required String city,
    File? photo,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      final teamsRepo = ref.read(teamsRepositoryProvider);
      String finalTeamId;

      if (teamId != null) {
        final result = await teamsRepo.updateById(
          UpdateTeamParams(teamId: teamId, name: name, city: city),
        );
        finalTeamId = result.id;
      } else {
        final result = await teamsRepo.createTeam(
          CreateTeamParams(name: name, city: city, playerIds: []),
        );
        finalTeamId = result.id;
      }

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        final filename = photo.uri.pathSegments.isNotEmpty
            ? photo.uri.pathSegments.last
            : 'team_avatar.jpg';
        await teamsRepo.uploadTeamPhoto(finalTeamId, bytes, filename);
      }

      ref.invalidate(teamsListProvider);
      ref.invalidate(teamDetailProvider);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: kDebugMode ? e.toString() : "Ошибка сохранения команды",
      );
    }
  }
}

final editTeamProvider =
    NotifierProvider.autoDispose<EditTeamNotifier, EditTeamState>(
      EditTeamNotifier.new,
    );
