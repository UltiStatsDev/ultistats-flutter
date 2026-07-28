import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';
import 'package:ultistats/features/players/presentation/providers/players_providers.dart';

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
  EditPlayerState build() {
    return const EditPlayerState();
  }

  Future<void> savePlayer({
    required String firstName,
    required String lastName,
    String? teamId,
    File? photo,
  }) async {
    /// Включаем загрузку
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      final playersRepo = ref.read(playersRepositoryProvider);
      final teamsRepo = ref.read(teamsRepositoryProvider);

      /// Создаем игрока
      final player = await playersRepo.createPlayer(
        CreatePlayerParams(firstName: firstName, lastName: lastName),
      );

      /// Если выбрана команда, привязываем
      if (teamId != null && teamId.isNotEmpty) {
        await teamsRepo.addPlayerToTeam(teamId, player.id);
      }

      /// Если есть фото, загружаем
      if (photo != null) {
        final bytes = await photo.readAsBytes();
        final filename = photo.uri.pathSegments.isNotEmpty
            ? photo.uri.pathSegments.last
            : 'avatar.jpg';

        await playersRepo.uploadPlayerPhoto(player.id, bytes, filename);
      }

      ref.invalidate(playersListProvider);

      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      final isDebugMode = kDebugMode;
      final error = isDebugMode ? e.toString() : "Ошибка сохранения игрока";
      state = state.copyWith(isLoading: false, error: error);
    }
  }
}


