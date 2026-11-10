import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/data/models/page_model.dart';
import 'package:ultistats/features/matches/data/models/match_detail_model.dart';
import 'package:ultistats/features/matches/data/models/match_list_item_model.dart';
import 'package:ultistats/features/matches/data/models/match_participant_model.dart';
import 'package:ultistats/features/matches/data/models/match_team_model.dart';
import 'package:ultistats/features/matches/data/repositories/matches_repository_impl.dart';
import 'package:ultistats/features/matches/data/requests/create_match_request.dart';
import 'package:ultistats/features/matches/data/requests/match_filter_request.dart';
import 'package:ultistats/features/matches/data/requests/match_timestamp_request.dart';
import 'package:ultistats/features/matches/data/requests/update_match_request.dart';
import 'package:ultistats/features/matches/data/sources/matches_api.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';
import 'package:ultistats/features/matches/domain/params/update_match_params.dart';

class FakeMatchesApi implements MatchesApi {
  FakeMatchesApi({
    this.matchesPage,
    this.matchDetail,
    this.startMatchResult,
    this.endMatchResult,
    this.lastCreateBody,
    this.lastUpdateBody,
  });

  Future<PageModel<MatchListItemModel>>? matchesPage;
  Future<MatchDetailModel>? matchDetail;
  Future<MatchDetailModel>? startMatchResult;
  Future<MatchDetailModel>? endMatchResult;

  CreateMatchRequest? lastCreateBody;
  UpdateMatchRequest? lastUpdateBody;
  MatchTimestampRequest? lastStartRequest;
  MatchTimestampRequest? lastEndRequest;

  int deleteMatchCallCount = 0;

  @override
  Future<PageModel<MatchListItemModel>> getMatches(
    MatchFilterRequest queries,
  ) {
    return matchesPage!;
  }

  @override
  Future<void> createMatch(CreateMatchRequest body) async {
    lastCreateBody = body;
  }

  @override
  Future<MatchDetailModel> getMatchById(String id) {
    return matchDetail!;
  }

  @override
  Future<void> updateMatch(String id, UpdateMatchRequest body) async {
    lastUpdateBody = body;
  }

  @override
  Future<void> deleteMatch(String id) async {
    deleteMatchCallCount++;
  }

  @override
  Future<MatchDetailModel> startMatch(String id, MatchTimestampRequest body) {
    lastStartRequest = body;
    return startMatchResult!;
  }

  @override
  Future<MatchDetailModel> endMatch(String id, MatchTimestampRequest body) {
    lastEndRequest = body;
    return endMatchResult!;
  }
}

void main() {
  late FakeMatchesApi api;
  late MatchesRepositoryImpl repository;

  setUp(() {
    api = FakeMatchesApi();
    repository = MatchesRepositoryImpl(api);
  });

  group('MatchesRepositoryImpl', () {
    group('getList', () {
      test('maps api page to domain entities and keeps pagination', () async {
        api.matchesPage = Future.value(
          PageModel<MatchListItemModel>(
            content: [
              MatchListItemModel(
                id: 'match-1',
                teams: [
                  MatchListTeamModel(
                    teamId: 'team-1',
                    teamName: 'Team One',
                    teamScore: 2,
                    city: 'Moscow',
                    photoUrl: 'https://example.com/team-1',
                  ),
                ],
                plannedStartTimestamp: DateTime.utc(2026, 1, 1),
                startedAt: null,
                endedAt: null,
                status: 'FINISHED',
              ),
            ],
            totalElements: 1,
            totalPages: 1,
            currentPage: 0,
            size: 20,
          ),
        );

        final result = await repository.getList(
          const MatchFilterParams(page: 0, size: 20),
        );

        expect(result.content.length, 1);
        final match = result.content.first;
        expect(match.id, 'match-1');
        expect(match.status, MatchStatus.finished);
        expect(match.teams.length, 1);
        expect(match.teams.first.teamId, 'team-1');
        expect(match.teams.first.teamName, 'Team One');
        expect(match.teams.first.teamScore, 2);
        expect(match.teams.first.city, 'Moscow');
        expect(match.teams.first.photoUrl, 'https://example.com/team-1');

        expect(result.totalElements, 1);
        expect(result.totalPages, 1);
        expect(result.currentPage, 0);
        expect(result.size, 20);
      });
    });

    group('getById', () {
      test('maps match detail with teams and participants to entity', () async {
        api.matchDetail = Future.value(
          MatchDetailModel(
            id: 'match-1',
            teams: [
              MatchTeamModel(
                teamId: 'team-1',
                teamName: 'Team One',
                teamScore: 1,
                participants: [
                  MatchParticipantModel(
                    participantId: 'player-1',
                    kind: 'PLAYER',
                    firstName: 'Ivan',
                    lastName: 'Ivanov',
                    displayName: 'Ivan Ivanov',
                    number: 7,
                    photoUrl: null,
                  ),
                ],
                city: null,
                photoUrl: null,
              ),
            ],
            eventCount: 3,
            playersPerTeam: 5,
            plannedStartTimestamp: DateTime.utc(2026, 1, 1),
            startedAt: DateTime.utc(2026, 1, 2),
            endedAt: null,
            status: 'IN_PROGRESS',
          ),
        );

        final result = await repository.getById('match-1');

        expect(result.id, 'match-1');
        expect(result.status, MatchStatus.inProgress);
        expect(result.eventCount, 3);
        expect(result.playersPerTeam, 5);
        expect(result.startedAt, DateTime.utc(2026, 1, 2));
        expect(result.teams.length, 1);
        expect(result.teams.first.score, 1);
        expect(result.teams.first.participants.length, 1);
        expect(result.teams.first.participants.first.kind, ParticipantKind.player);
        expect(result.teams.first.participants.first.number, 7);
      });
    });

    group('startMatch', () {
      test('sends start timestamp and returns mapped detail', () async {
        api.startMatchResult = Future.value(
          MatchDetailModel(
            id: 'match-1',
            teams: const [],
            eventCount: 0,
            playersPerTeam: 5,
            status: 'PLANNED',
          ),
        );

        final result = await repository.startMatch(
          'match-1',
          DateTime.utc(2026, 1, 1, 12, 0, 0),
        );

        expect(api.lastStartRequest?.timestamp, '2026-01-01T12:00:00.000Z');
        expect(result.id, 'match-1');
        expect(result.status, MatchStatus.planned);
      });
    });

    group('endMatch', () {
      test('sends end timestamp and returns mapped detail', () async {
        api.endMatchResult = Future.value(
          MatchDetailModel(
            id: 'match-1',
            teams: const [],
            eventCount: 0,
            playersPerTeam: 5,
            status: 'FINISHED',
          ),
        );

        final result = await repository.endMatch('match-1', DateTime.utc(2026, 1, 1, 13, 30, 0));

        expect(api.lastEndRequest?.timestamp, '2026-01-01T13:30:00.000Z');
        expect(result.id, 'match-1');
        expect(result.status, MatchStatus.finished);
      });
    });

    group('createMatch', () {
      test('maps create params to request', () async {
        await repository.createMatch(
          const CreateMatchParams(
            teamIds: ['team-1', 'team-2'],
            plannedStartTimestamp: null,
            playersPerTeam: 5,
          ),
        );

        expect(api.lastCreateBody?.teamIds, ['team-1', 'team-2']);
        expect(api.lastCreateBody?.playersPerTeam, 5);
        expect(api.lastCreateBody?.plannedStartTimestamp, isNull);
      });
    });

    group('updateMatch', () {
      test('maps update params to request', () async {
        await repository.updateById(
          const UpdateMatchParams(
            matchId: 'match-1',
            teamIds: ['team-1'],
            plannedStartTimestamp: null,
            playersPerTeam: 7,
          ),
        );

        expect(api.lastUpdateBody?.teamIds, ['team-1']);
        expect(api.lastUpdateBody?.playersPerTeam, 7);
        expect(api.lastUpdateBody?.plannedStartTimestamp, isNull);
      });
    });

    group('deleteMatch', () {
      test('delegates deletion to api', () async {
        await repository.deleteById('match-1');

        expect(api.deleteMatchCallCount, 1);
      });
    });
  });
}
