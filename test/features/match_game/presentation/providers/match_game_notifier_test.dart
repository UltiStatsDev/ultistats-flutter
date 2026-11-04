import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/core/di.dart';
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
import 'package:ultistats/features/match_game/presentation/providers/match_game_notifier.dart';
import 'package:ultistats/features/match_game/domain/match_game_state.dart';
import 'package:ultistats/features/match_game/domain/match_action.dart';
import 'package:ultistats/features/match_game/presentation/providers/match_timer_notifier.dart';

class FakeMatchEventsRepository implements MatchEventsRepository {
  final List<CreateEventParams> addedEvents = [];
  Completer<void>? addEventGate;

  @override
  Future<List<Event>> getEvents(String matchId) async => const [];

  @override
  Future<void> addEvent(CreateEventParams params) async {
    await addEventGate?.future;
    addedEvents.add(params);
  }

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
  Object? endMatchError;
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
    if (endMatchError != null) {
      throw endMatchError!;
    }
    final result = endMatchResult!;
    return result;
  }
}

void main() {
  final match = MatchDetail(    id: 'match-1',
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
    matchesRepository = FakeMatchesRepository(endMatchResult: Future.value(match));
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        matchTimerProvider.overrideWith2((matchId) => FakeMatchTimer()),
        matchEventsRepositoryProvider.overrideWithValue(eventsRepository),
        matchesRepositoryProvider.overrideWithValue(matchesRepository),
      ],
    );
    addTearDown(container.dispose);
    container.listen(matchGameProvider(match), (_, _) {});
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

    test('full game flow: lineup -> puller -> taker -> playing -> goal', () async {
      final container = createContainer();
      final notifier = container.read(matchGameProvider(match).notifier);

      final state = container.read<MatchGameState>(matchGameProvider(match));
      expect(state, isA<GameStateLineupSelection>());

      notifier.dispatch(TogglePlayerAction(participantId: 'p-1', teamIndex: 0));
      notifier.dispatch(TogglePlayerAction(participantId: 'p-2', teamIndex: 0));
      notifier.dispatch(TogglePlayerAction(participantId: 'p-3', teamIndex: 1));
      notifier.dispatch(TogglePlayerAction(participantId: 'p-4', teamIndex: 1));

      final fullLineup = container.read<MatchGameState>(matchGameProvider(match)) as GameStateLineupSelection;
      expect(fullLineup.team1SelectedIds.length, 2);
      expect(fullLineup.team2SelectedIds.length, 2);

      notifier.dispatch(ConfirmLineupAction(pullingTeamId: 'team-1'));
      final pullerState = container.read<MatchGameState>(matchGameProvider(match)) as GameStatePullerSelection;
      expect(pullerState.activeTeam.id, 'team-1');

      notifier.dispatch(SelectPullerAction(pullerState.activeTeamLineup[0]));
      final takerState = container.read<MatchGameState>(matchGameProvider(match)) as GameStateTakerSelection;
      expect(takerState.activeTeam.id, 'team-2');

      notifier.dispatch(SelectTakerAction(takerState.activeTeamLineup[0]));
      final playingState = container.read<MatchGameState>(matchGameProvider(match)) as GameStatePlaying;
      expect(
        playingState.currentThrower.participantId,
        takerState.activeTeamLineup[0].participantId,
      );

      notifier.dispatch(ScoreGoalAction(playingState.activeTeamLineup[0]));
      final afterGoal = container.read<MatchGameState>(matchGameProvider(match)) as GameStateLineupSelection;
      expect(afterGoal.match.teams[0].score, 0);
      expect(afterGoal.match.teams[1].score, 1);
    });

    test('finish match ends it and transitions to finished state', () async {
      final container = createContainer();
      final notifier = container.read(matchGameProvider(match).notifier);

      final state = container.read<MatchGameState>(matchGameProvider(match));
      expect(state, isA<GameStateLineupSelection>());

      notifier.dispatch(TogglePlayerAction(participantId: 'p-1', teamIndex: 0));
      notifier.dispatch(TogglePlayerAction(participantId: 'p-2', teamIndex: 0));
      notifier.dispatch(TogglePlayerAction(participantId: 'p-3', teamIndex: 1));
      notifier.dispatch(TogglePlayerAction(participantId: 'p-4', teamIndex: 1));

      var lineupState = container.read<MatchGameState>(matchGameProvider(match)) as GameStateLineupSelection;
      notifier.dispatch(ConfirmLineupAction(pullingTeamId: 'team-1'));
      var pullerState = container.read<MatchGameState>(matchGameProvider(match)) as GameStatePullerSelection;
      notifier.dispatch(SelectPullerAction(pullerState.activeTeamLineup[0]));
      var takerState = container.read<MatchGameState>(matchGameProvider(match)) as GameStateTakerSelection;
      notifier.dispatch(SelectTakerAction(takerState.activeTeamLineup[0]));
      var playingState = container.read<MatchGameState>(matchGameProvider(match)) as GameStatePlaying;
      notifier.dispatch(ScoreGoalAction(playingState.activeTeamLineup[0]));
      lineupState = container.read<MatchGameState>(matchGameProvider(match)) as GameStateLineupSelection;

      expect(lineupState.team1SelectedIds.length, 2);
      expect(lineupState.team2SelectedIds.length, 2);

      await notifier.finishMatch();
      await Future<void>.delayed(Duration.zero);

      expect(matchesRepository.endMatchId, 'match-1');
      final finishedState = container.read<MatchGameState>(matchGameProvider(match));
      expect(finishedState, isA<GameStateFinished>());
      expect(finishedState.match.id, 'match-1');
      expect((finishedState as GameStateFinished).isSyncing, isFalse);
    });

    test('finish match waits for queued events before ending it', () async {
      final container = createContainer();
      final notifier = container.read(matchGameProvider(match).notifier);

      eventsRepository.addEventGate = Completer<void>();
      container
          .read(matchEventQueueProvider)
          .enqueue('match-1', MatchEvent.halftimeStart());

      final finishing = notifier.finishMatch();

      final syncingState =
          container.read<MatchGameState>(matchGameProvider(match))
              as GameStateFinished;
      expect(syncingState.isSyncing, isTrue);
      expect(matchesRepository.endMatchId, isNull);

      eventsRepository.addEventGate!.complete();
      await finishing;

      expect(eventsRepository.addedEvents, hasLength(1));
      expect(matchesRepository.endMatchId, 'match-1');
      final finishedState =
          container.read<MatchGameState>(matchGameProvider(match))
              as GameStateFinished;
      expect(finishedState.isSyncing, isFalse);
    });

    test('finish match returns to lineup state when endMatch fails', () async {
      final container = createContainer();
      final notifier = container.read(matchGameProvider(match).notifier);
      final before = container.read<MatchGameState>(matchGameProvider(match));

      matchesRepository.endMatchError = Exception('network');

      await notifier.finishMatch();

      expect(container.read<MatchGameState>(matchGameProvider(match)), same(before));
    });
  });
}
