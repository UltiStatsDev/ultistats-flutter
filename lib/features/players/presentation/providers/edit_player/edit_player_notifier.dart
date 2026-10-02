import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';
import 'package:ultistats/features/players/presentation/providers/edit_player/edit_player_state.dart';
import 'package:ultistats/features/players/presentation/providers/player_detail/player_detail_notifier.dart';
import 'package:ultistats/features/players/presentation/providers/player_list/players_list_notifier.dart';

class EditPlayerNotifier extends Notifier<EditPlayerState> {
  @override
  EditPlayerState build() => const EditPlayerInitial();

  Future<void> deleteImage(String playerId) async {
    try {
      final playersRepo = ref.read(playersRepositoryProvider);
      await playersRepo.deletePlayerPhoto(playerId);
      ref.invalidate(playerDetailProvider);
      ref.invalidate(playersListProvider);
    } catch (e, st) {
      log(
        "Error while deleting player photo",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
    }
  }

  Future<void> deletePlayer({required String id}) async {
    state = EditPlayerLoading();

    try {
      final playersRepo = ref.read(playersRepositoryProvider);
      await playersRepo.deleteById(id);

      ref.invalidate(playerDetailProvider);
      ref.invalidate(playersListProvider);

      state = EditPlayerDeleted();
    } catch (e, st) {
      log(
        "Error while deletePlayer",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
      state = EditPlayerError(error: e, stackTrace: st);
    }
  }

  Future<void> savePlayer({
    String? playerId,
    required String firstName,
    required String lastName,
    File? photo,
  }) async {
    state = EditPlayerLoading();

    try {
      final playersRepo = ref.read(playersRepositoryProvider);

      String finalPlayerId;

      if (playerId != null) {
        final player = await playersRepo.updateById(
          UpdatePlayerParams(
            playerId: playerId,
            firstName: firstName,
            lastName: lastName,
          ),
        );
        finalPlayerId = player.id;
      } else {
        final player = await playersRepo.createPlayer(
          CreatePlayerParams(firstName: firstName, lastName: lastName),
        );
        finalPlayerId = player.id;
      }

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        final filename = photo.uri.pathSegments.isNotEmpty
            ? photo.uri.pathSegments.last
            : 'avatar.jpg';
        await playersRepo.uploadPlayerPhoto(finalPlayerId, bytes, filename);
      }

      ref.invalidate(playersListProvider);
      state = EditPlayerSaved();
    } catch (e, st) {
      log(
        "Error while savePlayer",
        error: e,
        stackTrace: st,
        name: runtimeType.toString(),
      );
      state = EditPlayerError(error: e, stackTrace: st);
    }
  }
}

final editPlayerProvider =
    NotifierProvider.autoDispose<EditPlayerNotifier, EditPlayerState>(
      EditPlayerNotifier.new,
    );
