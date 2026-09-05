import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/teams/presentation/providers/team_detail_state.dart';

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
      final player = await repository.getById(id);

      state = TeamDetailLoaded(player);
    } catch (e, st) {
      state = TeamDetailError(e, st);
    }
  }

  Future<void> refresh() async {
    state = const TeamDetailLoading();
    await _loadTeam(id);
  }
}
