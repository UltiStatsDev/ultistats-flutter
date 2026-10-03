import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/teams/domain/params/create_team_params.dart';
import 'package:ultistats/features/teams/domain/params/update_team_params.dart';
import 'package:ultistats/features/teams/presentation/providers/edit_team/edit_team_state.dart';
import 'package:ultistats/features/teams/presentation/providers/team_detail/team_detail_notifier.dart';
import 'package:ultistats/features/teams/presentation/providers/team_list/teams_list_notifier.dart';

class EditTeamNotifier extends Notifier<EditTeamState> {
  @override
  EditTeamState build() => const EditTeamInitial();

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

  Future<void> deleteTeam({required String id}) async {
    state = EditTeamLoading();

    try {
      final teamsRepo = ref.read(teamsRepositoryProvider);
      await teamsRepo.deleteById(id);
      ref.invalidate(teamsListProvider);
      state = EditTeamDeleted();
    } catch (e, st) {
      log(
        "Error while deleteTeam",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
      state = EditTeamError(error: e, stackTrace: st);
    }
  }

  Future<void> saveTeam({
    String? teamId,
    required String name,
    required String city,
    File? photo,
  }) async {
    state = EditTeamLoading();

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
      state = EditTeamSaved();
    } catch (e, st) {
      log(
        "Error while saveTeam",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
      state = EditTeamError(error: e, stackTrace: st);
    }
  }
}

final editTeamProvider =
    NotifierProvider.autoDispose<EditTeamNotifier, EditTeamState>(
      EditTeamNotifier.new,
    );
