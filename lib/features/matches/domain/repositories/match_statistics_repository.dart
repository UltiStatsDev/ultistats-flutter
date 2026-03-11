import 'package:ultistats/features/matches/domain/entities/match_statistics.dart';

abstract interface class MatchStatisticsRepository {
  Future<MatchStatistics> getStatistics(String matchId);
}
