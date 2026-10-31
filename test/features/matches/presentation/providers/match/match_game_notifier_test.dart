import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/matches/data/models/event_model.dart';
import 'package:ultistats/core/domain/entities/page.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/matches/domain/entities/match_list_item.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';
import 'package:ultistats/features/matches/domain/params/update_event_params.dart';
import 'package:ultistats/features/matches/domain/params/update_match_params.dart';
import 'package:ultistats/features/matches/domain/repositories/match_events_repository.dart';
import 'package:ultistats/features/matches/domain/repositories/matches_repository.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_notifier.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_game_state.dart';
import 'package:ultistats/features/matches/presentation/providers/match/match_timer_notifier.dart';

class FakeMatchEventsRepository implements MatchEventsRepository {
  final List<CreateEventParams> addedEvents = [];

  @override
  Future<List<Event>> getEvents(String matchId) async => const [];

  @override
  Future<Event> addEvent(CreateEventParams params) async {
    addedEvents.add(params);
    return EventModel.fromJson({
      ...EventModel.fromEntity(params.event).toJson(),
      'id': 'event-${addedEvents.length}',
      'sequenceNumber': addedEvents.length,
    }).toEntity();
  }

  @override
  Future<Event> undoLastEvent(String matchId) async =>
      throw UnimplementedError();

  @override
  Future<void> updateEvent(UpdateEventParams params) async {}

  @override
  Future<void> deleteEvent(String matchId, String eventId) async {}
}

class FakeMatchTimer extends MatchTimer {
  @override
  void start({Duration? initialDuration}) {}
}

class FakeMatchesRepository implements MatchesRepository {
  FakeMatchesRepository({this.endMatchResult});

  final Future<MatchDetail>? endMatchResult;
  String? endMatchId;
  DateTime? endMatchDate;

  @override
  Future<Page<MatchListItem>> getList(MatchFilterParams params) async {
    throw UnimplementedError();
  }

  @override
  Future<void> createMatch(CreateMatchParams params) async {}

  @override
  Future<MatchDetail> getById(String matchId) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateById(UpdateMatchParams params) async {}

  @override
  Future<void> deleteById(String matchId) async {}

  @override
  Future<MatchDetail> startMatch(String matchId, DateTime date) async {
    throw UnimplementedError();
  }

  @override
  Future<MatchDetail> endMatch(String matchId, DateTime date) async {
    endMatchId = matchId;
    endMatchDate = date;
    final result = endMatchResult!;
    return result;
  }
}

void main() {
  final match = MatchDetail(
    id: 'match-1',
    teams: [
      MatchTeam(
        id: 'team-1',
        name: 'Team One',
        score: 0,
        participants: [
          MatchParticipant(
            participantId: 'p-1',
            kind: ParticipantKind.player,
            firstName: 'Ivan',
            lastName: 'Ivanov',
            displayName: 'Ivan Ivanov',
            number: 7,
            photoUrl: null,
          ),
          MatchParticipant(
            participantId: 'p-2',
            kind: ParticipantKind.player,
            firstName: 'Petr',
            lastName: 'Petrov',
            displayName: 'Petr Petrov',
            number: 8,
            photoUrl: null,
          ),
        ],
        city: 'Moscow',
        photoUrl: null,
      ),
      MatchTeam(
        id: 'team-2',
        name: 'Team Two',
        score: 0,
        participants: [
          MatchParticipant(
            participantId: 'p-3',
            kind: ParticipantKind.player,
            firstName: 'Sasha',
            lastName: 'Sashirov',
            displayName: 'Sasha Sashirov',
            number: 9,
            photoUrl: null,
          ),
          MatchParticipant(
            participantId: 'p-4',
            kind: ParticipantKind.player,
            firstName: 'Kolya',
            lastName: 'Kolyaev',
            displayName: 'Kolya Kolyaev',
            number: 10,
            photoUrl: null,
          ),
        ],
        city: null,
        photoUrl: null,
      ),
    ],
    eventCount: 0,
    playersPerTeam: 2,
    status: MatchStatus.planned,
  );

  late FakeMatchEventsRepository eventsRepository;
  late FakeMatchesRepository matchesRepository;

  setUp(() {
    eventsRepository = FakeMatchEventsRepository();
    matchesRepository = FakeMatchesRepository(
      endMatchResult: Future.value(match),
    );
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        matchTimerProvider.overrideWith2((matchId) => FakeMatchTimer()),
        matchEventsRepositoryProvider.overrideWithValue(eventsRepository),
        matchesRepositoryProvider.overrideWithValue(matchesRepository),
      ],
    );
    container.listen(matchGameProvider(match), (_, _) {});
    addTearDown(container.dispose);
    return container;
  }

  group('MatchGameNotifier', () {
    test('game starts in lineup selection state', () {
      final container = createContainer();
      final state = container.read<MatchGameState>(matchGameProvider(match));

      expect(state, isA<GameStateLineupSelection>());
      final lineup = state as GameStateLineupSelection;
      expect(lineup.match.id, 'match-1');
      expect(lineup.team1SelectedIds, isEmpty);
      expect(lineup.team2SelectedIds, isEmpty);
    });

    test(
      'full game flow: lineup -> puller -> taker -> playing -> goal',
      () async {
        final container = createContainer();
        final notifier = container.read(matchGameProvider(match).notifier);

        final state = container.read<MatchGameState>(matchGameProvider(match));
        expect(state, isA<GameStateLineupSelection>());

        notifier.togglePlayer('p-1', 0);
        notifier.togglePlayer('p-2', 0);
        notifier.togglePlayer('p-3', 1);
        notifier.togglePlayer('p-4', 1);

        final fullLineup =
            container.read<MatchGameState>(matchGameProvider(match))
                as GameStateLineupSelection;
        expect(fullLineup.team1SelectedIds.length, 2);
        expect(fullLineup.team2SelectedIds.length, 2);

        notifier.confirmLineupAndStartPull('team-1');
        final pullerState =
            container.read<MatchGameState>(matchGameProvider(match))
                as GameStatePullerSelection;
        expect(pullerState.activeTeam.id, 'team-1');

        notifier.selectPuller(pullerState.activeTeamLineup[0]);
        await Future<void>.delayed(Duration.zero);
        final takerState =
            container.read<MatchGameState>(matchGameProvider(match))
                as GameStateTakerSelection;
        expect(takerState.activeTeam.id, 'team-2');

        notifier.selectTaker(takerState.activeTeamLineup[0]);
        await Future<void>.delayed(Duration.zero);
        final playingState =
            container.read<MatchGameState>(matchGameProvider(match))
                as GameStatePlaying;
        expect(
          playingState.currentThrower.participantId,
          takerState.activeTeamLineup[0].participantId,
        );

        notifier.scoreGoal(playingState.activeTeamLineup[0]);
        await Future<void>.delayed(Duration.zero);
        final afterGoal =
            container.read<MatchGameState>(matchGameProvider(match))
                as GameStateLineupSelection;
        expect(afterGoal.match.teams[0].score, 0);
        expect(afterGoal.match.teams[1].score, 1);
      },
    );

    test('finish match ends it and transitions to finished state', () async {
      final container = createContainer();
      final notifier = container.read(matchGameProvider(match).notifier);

      final state = container.read<MatchGameState>(matchGameProvider(match));
      expect(state, isA<GameStateLineupSelection>());

      notifier.togglePlayer('p-1', 0);
      notifier.togglePlayer('p-2', 0);
      notifier.togglePlayer('p-3', 1);
      notifier.togglePlayer('p-4', 1);

      var lineupState =
          container.read<MatchGameState>(matchGameProvider(match))
              as GameStateLineupSelection;
      notifier.confirmLineupAndStartPull('team-1');
      var pullerState =
          container.read<MatchGameState>(matchGameProvider(match))
              as GameStatePullerSelection;
      notifier.selectPuller(pullerState.activeTeamLineup[0]);
      await Future<void>.delayed(Duration.zero);
      var takerState =
          container.read<MatchGameState>(matchGameProvider(match))
              as GameStateTakerSelection;
      notifier.selectTaker(takerState.activeTeamLineup[0]);
      await Future<void>.delayed(Duration.zero);
      var playingState =
          container.read<MatchGameState>(matchGameProvider(match))
              as GameStatePlaying;
      notifier.scoreGoal(playingState.activeTeamLineup[0]);
      await Future<void>.delayed(Duration.zero);
      lineupState =
          container.read<MatchGameState>(matchGameProvider(match))
              as GameStateLineupSelection;

      expect(lineupState.team1SelectedIds.length, 2);
      expect(lineupState.team2SelectedIds.length, 2);

      await notifier.finishMatch();

      expect(matchesRepository.endMatchId, 'match-1');
      final finishedState = container.read<MatchGameState>(
        matchGameProvider(match),
      );
      expect(finishedState, isA<GameStateFinished>());
      expect(finishedState.match.id, 'match-1');
    });
  });
}
