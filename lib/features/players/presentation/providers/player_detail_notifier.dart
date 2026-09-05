import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/players/presentation/providers/player_detail_state.dart';

part 'player_detail_notifier.g.dart';

@riverpod
class PlayerDetailNotifier extends _$PlayerDetailNotifier {
  @override
  PlayerDetailState build(String id) {
    _loadPlayer(id);
    return const PlayerDetailLoading();
  }

  Future<void> _loadPlayer(String id) async {
    try {
      final repository = ref.read(playersRepositoryProvider);
      final player = await repository.getById(id);

      state = PlayerDetailLoaded(player);
    } catch (e, st) {
      state = PlayerDetailError(e, st);
    }
  }

  Future<void> refresh() async {
    state = const PlayerDetailLoading();
    await _loadPlayer(id);
  }
}
