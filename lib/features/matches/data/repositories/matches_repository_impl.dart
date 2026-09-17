import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/matches/data/models/create_match_request.dart';
import 'package:ultistats/features/matches/data/models/match_filter_request.dart';
import 'package:ultistats/features/matches/data/models/match_timestamp_request.dart';
import 'package:ultistats/features/matches/data/models/update_match_request.dart';
import 'package:ultistats/features/matches/data/sources/matches_api.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_list_item.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';
import 'package:ultistats/features/matches/domain/params/update_match_params.dart';
import 'package:ultistats/features/matches/domain/repositories/matches_repository.dart';

class MatchesRepositoryImpl implements MatchesRepository {
  final MatchesApi _api;

  MatchesRepositoryImpl(this._api);

  @override
  Future<void> createMatch(CreateMatchParams params) async {
    final request = CreateMatchRequest.fromParams(params);
    return await _api.createMatch(request);
  }

  @override
  Future<void> deleteById(String matchId) {
    return _api.deleteMatch(matchId);
  }

  @override
  Future<MatchDetail> endMatch(String matchId, DateTime date) async {
    final request = MatchTimestampRequest.fromDateTime(date);
    final model = await _api.endMatch(matchId, request);
    return model.toEntity();
  }

  @override
  Future<MatchDetail> getById(String matchId) async {
    final model = await _api.getMatchById(matchId);
    return model.toEntity();
  }

  @override
  Future<Page<MatchListItem>> getList(MatchFilterParams params) async {
    final request = MatchFilterRequest.fromParams(params);
    final pageModel = await _api.getMatches(request);

    return Page<MatchListItem>(
      content: pageModel.content.map((m) => m.toEntity()).toList(),
      totalElements: pageModel.totalElements,
      totalPages: pageModel.totalPages,
      currentPage: pageModel.currentPage,
      size: pageModel.size,
    );
  }

  @override
  Future<void> updateById(UpdateMatchParams params) async {
    final request = UpdateMatchRequest.fromParams(params);
    return await _api.updateMatch(params.matchId, request);
  }

  @override
  Future<MatchDetail> startMatch(String matchId, DateTime date) async {
    final request = MatchTimestampRequest.fromDateTime(date);
    final model = await _api.startMatch(matchId, request);
    return model.toEntity();
  }
}
