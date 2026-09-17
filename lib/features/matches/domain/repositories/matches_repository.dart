import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_list_item.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';
import 'package:ultistats/features/matches/domain/params/update_match_params.dart';

abstract interface class MatchesRepository {
  Future<Page<MatchListItem>> getList(MatchFilterParams params);

  Future<void> createMatch(CreateMatchParams params);

  Future<MatchDetail> getById(String matchId);

  Future<void> updateById(UpdateMatchParams params);

  Future<void> deleteById(String matchId);

  Future<MatchDetail> startMatch(String matchId, DateTime date);

  Future<MatchDetail> endMatch(String matchId, DateTime date);
}
