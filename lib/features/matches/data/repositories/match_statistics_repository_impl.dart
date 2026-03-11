import 'package:ultistats/features/matches/data/sources/match_statistics_api.dart';
import 'package:ultistats/features/matches/domain/entities/match_statistics.dart';
import 'package:ultistats/features/matches/domain/repositories/match_statistics_repository.dart';

class MatchStatisticsRepositoryImpl implements MatchStatisticsRepository {
  final MatchStatisticsApi _api;

  MatchStatisticsRepositoryImpl(this._api);

  @override
  Future<MatchStatistics> getStatistics(String matchId) async {
    final model = await _api.getMatchStatistics(matchId);
    return model.toEntity();
  }
}
