import 'package:ultistats/core/entities/page.dart';
import 'package:ultistats/features/matches/domain/entities/match.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';

abstract interface class MatchesRepository {
  Future<Page<Match>> getList(MatchFilterParams params);

  Future<Match> createMatch(CreateMatchParams params);

  Future<Match> startMatch(String matchId, DateTime date);

  Future<Match> endMatch(String matchId, DateTime date);

  Future<Match> getById(String matchId);

  Future<void> deleteById(String matchId);
}
