import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';
import 'package:ultistats/features/players/presentation/providers/players_list_notifier.dart';

class EditPlayerState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const EditPlayerState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  EditPlayerState copyWith({bool? isLoading, String? error, bool? isSuccess}) {
    return EditPlayerState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class EditPlayerNotifier extends Notifier<EditPlayerState> {
  @override
  EditPlayerState build() => const EditPlayerState();

  Future<void> savePlayer({
    String? playerId,
    required String firstName,
    required String lastName,
    String? teamId,
    File? photo,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      final playersRepo = ref.read(playersRepositoryProvider);
      final teamsRepo = ref.read(teamsRepositoryProvider);

      String finalPlayerId;

      if (playerId != null) {
        // Обновляем существующего
        final player = await playersRepo.updateById(
          UpdatePlayerParams(
            playerId: playerId,
            firstName: firstName,
            lastName: lastName,
          ),
        );
        finalPlayerId = player.id;
      } else {
        // Создаем нового
        final player = await playersRepo.createPlayer(
          CreatePlayerParams(firstName: firstName, lastName: lastName),
        );
        finalPlayerId = player.id;
      }

      // Привязка к команде и загрузка фото общие для обоих случаев
      // TODO номер убрать
      if (teamId != null && teamId.isNotEmpty) {
        await teamsRepo.addOrUpdatePlayerInTeam(teamId, finalPlayerId, 0);
      }

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        final filename = photo.uri.pathSegments.isNotEmpty
            ? photo.uri.pathSegments.last
            : 'avatar.jpg';
        await playersRepo.uploadPlayerPhoto(finalPlayerId, bytes, filename);
      }

      ref.invalidate(playersListProvider);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        error: kDebugMode ? e.toString() : "Ошибка сохранения игрока",
      );
    }
  }
}

final editPlayerProvider = NotifierProvider.autoDispose<EditPlayerNotifier, EditPlayerState>(
  EditPlayerNotifier.new,
);
