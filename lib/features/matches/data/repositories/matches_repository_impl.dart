import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/matches/data/models/create_match_request.dart';
import 'package:ultistats/features/matches/data/models/match_filter_request.dart';
import 'package:ultistats/features/matches/data/models/match_timestamp_request.dart';
import 'package:ultistats/features/matches/data/sources/matches_api.dart';
import 'package:ultistats/features/matches/domain/entities/match.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';
import 'package:ultistats/features/matches/domain/repositories/matches_repository.dart';

class MatchesRepositoryImpl implements MatchesRepository {
  final MatchesApi _api;

  MatchesRepositoryImpl(this._api);

  @override
  Future<Match> createMatch(CreateMatchParams params) async {
    final request = CreateMatchRequest.fromParams(params);
    final model = await _api.createMatch(request);
    return model.toEntity();
  }

  @override
  Future<void> deleteById(String matchId) {
    return _api.deleteMatch(matchId);
  }

  @override
  Future<Match> endMatch(String matchId, DateTime date) async {
    final request = MatchTimestampRequest.fromDateTime(date);
    final model = await _api.endMatch(matchId, request);
    return model.toEntity();
  }

  @override
  Future<Match> getById(String matchId) async {
    final model = await _api.getMatchById(matchId);
    return model.toEntity();
  }

  @override
  Future<Page<Match>> getList(MatchFilterParams params) async {
    final request = MatchFilterRequest.fromParams(params);
    final pageModel = await _api.getMatches(request);

    return Page<Match>(
      content: pageModel.content.map((m) => m.toEntity()).toList(),
      totalElements: pageModel.totalElements,
      totalPages: pageModel.totalPages,
      currentPage: pageModel.currentPage,
      size: pageModel.size,
    );
  }

  @override
  Future<Match> startMatch(String matchId, DateTime date) async {
    final request = MatchTimestampRequest.fromDateTime(date);
    final model = await _api.startMatch(matchId, request);
    return model.toEntity();
  }
}
