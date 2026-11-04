import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/features/matches/domain/matches_refresh.dart';
import 'package:ultistats/features/matches/presentation/providers/match_detail/match_detail_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match_list/matches_list_notifier.dart';

final matchesRefreshProvider = Provider<MatchesRefresh>((ref) {
  return _RiverpodMatchesRefresh(ref);
});

class _RiverpodMatchesRefresh implements MatchesRefresh {
  const _RiverpodMatchesRefresh(this._ref);

  final Ref _ref;

  @override
  void refreshDetail() => _ref.invalidate(matchDetailProvider);

  @override
  void refreshList() => _ref.invalidate(matchesListProvider);
}
