import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/matches/domain/entities/match.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';
import 'package:ultistats/features/matches/domain/params/update_match_params.dart';

abstract interface class MatchesRepository {
  Future<Page<Match>> getList(MatchFilterParams params);

  Future<Match> createMatch(CreateMatchParams params);

  Future<Match> getById(String matchId);

  Future<Match> updateById(UpdateMatchParams params);

  Future<void> deleteById(String matchId);

  Future<Match> startMatch(String matchId, DateTime date);

  Future<Match> endMatch(String matchId, DateTime date);
}
