import 'package:flutter_test/flutter_test.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';
import 'package:ultistats/features/match_game/domain/match_game_state.dart';
import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';
import 'package:ultistats/features/match_game/domain/match_action.dart';
import 'package:ultistats/features/match_game/domain/match_game_engine.dart';

const _engine = MatchGameEngine();

MatchParticipant _participant(String id, {ParticipantKind? kind}) {
  return MatchParticipant(
    participantId: id,
    kind: kind ?? ParticipantKind.player,
    firstName: null,
    lastName: null,
    displayName: id,
    number: null,
    photoUrl: null,
  );
}

MatchDetail _match() {
  return MatchDetail(
    id: 'match-1',
    teams: [
      MatchTeam(
        id: 'team-1',
        name: 'Team One',
        score: 0,
        participants: [
          _participant('a1'),
          _participant('a2'),
          _participant('a-unknown', kind: ParticipantKind.unknown),
        ],
      ),
      MatchTeam(
        id: 'team-2',
        name: 'Team Two',
        score: 0,
        participants: [
          _participant('b1'),
          _participant('b2'),
          _participant('b-unknown', kind: ParticipantKind.unknown),
        ],
      ),
    ],
    eventCount: 0,
    playersPerTeam: 2,
    status: MatchStatus.inProgress,
  );
}

GameStateLineupSelection _fullLineup(MatchDetail match) {
  return GameStateLineupSelection(
    match: match,
    team1SelectedIds: {'a1', 'a2'},
    team2SelectedIds: {'b1', 'b2'},
  );
}

/// Доводит игру до состояния `GameStatePlaying`.
GameStatePlaying _playing(MatchDetail match) {
  final puller = _engine.apply(
    _fullLineup(match),
    const ConfirmLineupAction(pullingTeamId: 'team-1'),
  )!;
  final taker = _engine.apply(
    puller.state,
    SelectPullerAction((puller.state as GameStatePullerSelection).activeTeamLineup.first),
  )!;
  return _engine.apply(
    taker.state,
    SelectTakerAction((taker.state as GameStateTakerSelection).activeTeamLineup.first),
  )!.state as GameStatePlaying;
}

void main() {
  group('togglePlayer', () {
    test('добавляет и снимает игрока', () {
      final state = GameStateLineupSelection(match: _match());

      final added = _engine.apply(
        state,
        const TogglePlayerAction(participantId: 'a1', teamIndex: 0),
      )!;
      expect(
        (added.state as GameStateLineupSelection).team1SelectedIds,
        {'a1'},
      );
      expect(added.events, isEmpty);

      final removed = _engine.apply(
        added.state,
        const TogglePlayerAction(participantId: 'a1', teamIndex: 0),
      )!;
      expect((removed.state as GameStateLineupSelection).team1SelectedIds, isEmpty);
    });

    test('не превышает playersPerTeam', () {
      final state = GameStateLineupSelection(
        match: _match(),
        team1SelectedIds: {'a1', 'a2'},
      );

      final result = _engine.apply(
        state,
        const TogglePlayerAction(participantId: 'a-unknown', teamIndex: 0),
      )!;

      expect((result.state as GameStateLineupSelection).team1SelectedIds, {
        'a1',
        'a2',
      });
    });

    test('недопустим вне выбора состава', () {
      final result = _engine.apply(
        _playing(_match()),
        const TogglePlayerAction(participantId: 'a1', teamIndex: 0),
      );

      expect(result, isNull);
    });
  });

  group('confirmLineup', () {
    test('переходит к выбору паллера и добавляет неизвестных игроков', () {
      final result = _engine.apply(
        _fullLineup(_match()),
        const ConfirmLineupAction(pullingTeamId: 'team-1'),
      )!;

      final state = result.state as GameStatePullerSelection;
      expect(state.activeTeam.id, 'team-1');
      expect(state.opponentTeam.id, 'team-2');
      expect(state.activeTeamLineup.map((p) => p.participantId), [
        'a1',
        'a2',
        'a-unknown',
      ]);
      expect(state.opponentTeamLineup.map((p) => p.participantId), [
        'b1',
        'b2',
        'b-unknown',
      ]);
    });

    test('недопустим при неполном составе', () {
      final result = _engine.apply(
        GameStateLineupSelection(
          match: _match(),
          team1SelectedIds: {'a1'},
          team2SelectedIds: {'b1', 'b2'},
        ),
        const ConfirmLineupAction(pullingTeamId: 'team-1'),
      );

      expect(result, isNull);
    });
  });

  group('игровой поток', () {
    test('паллер -> тейкер -> игра, события PULL и PICKUP', () {
      final match = _match();
      final puller = _engine.apply(
        _fullLineup(match),
        const ConfirmLineupAction(pullingTeamId: 'team-1'),
      )!;

      final pullerState = puller.state as GameStatePullerSelection;
      final afterPuller = _engine.apply(
        puller.state,
        SelectPullerAction(pullerState.activeTeamLineup.first),
      )!;

      expect(afterPuller.state, isA<GameStateTakerSelection>());
      expect(afterPuller.events.single.type, EventType.PULL);

      final takerState = afterPuller.state as GameStateTakerSelection;
      final taker = takerState.activeTeamLineup.first;
      final afterTaker = _engine.apply(
        afterPuller.state,
        SelectTakerAction(taker),
      )!;

      final playing = afterTaker.state as GameStatePlaying;
      expect(playing.currentThrower.participantId, taker.participantId);
      expect(afterTaker.events.single.type, EventType.PICKUP);
    });

    test('пас меняет бросающего и создаёт PASS', () {
      final playing = _playing(_match());
      final receiver = playing.activeTeamLineup[1];

      final result = _engine.apply(playing, PassToAction(receiver))!;
      final next = result.state as GameStatePlaying;

      expect(next.currentThrower.participantId, receiver.participantId);
      final event = result.events.single as Event2;
      expect(event.type, EventType.PASS);
      expect(event.participantId, playing.currentThrower.participantId);
      expect(event.toParticipantId, receiver.participantId);
    });

    test('перехват переключает активную команду', () {
      final playing = _playing(_match());

      final result = _engine.apply(
        playing,
        const DeclareTurnoverAction(),
      )!;
      final next = result.state as GameStateTakerSelection;

      expect(next.activeTeam.id, playing.opponentTeam.id);
      expect(result.events.single.type, EventType.INCOMPLETE_PASS);
    });

    test('гол увеличивает счёт и возвращает к выбору состава', () {
      final playing = _playing(_match());

      final result = _engine.apply(
        playing,
        ScoreGoalAction(playing.activeTeamLineup[1]),
      )!;
      final next = result.state as GameStateLineupSelection;

      expect(next.match.teams[0].score, 0);
      expect(next.match.teams[1].score, 1);
      expect(next.team1SelectedIds, {'a1', 'a2'});
      expect(next.team2SelectedIds, {'b1', 'b2'});
      expect(result.events.single.type, EventType.GOAL);
    });
  });

  group('паузы', () {
    test('таймаут доступен только владеющей команде', () {
      final playing = _playing(_match());

      expect(
        _engine.apply(playing, StartTimeoutAction(team: playing.opponentTeam)),
        isNull,
      );

      final result = _engine.apply(
        playing,
        StartTimeoutAction(team: playing.activeTeam),
      )!;
      final timeout = result.state as GameStateTimeout;

      expect(timeout.team.id, playing.activeTeam.id);
      expect(result.events.single.type, EventType.TIMEOUT_START);

      final resumed = _engine.apply(
        result.state,
        EndTimeoutAction(team: playing.activeTeam),
      )!;

      expect(resumed.state, same(playing));
      expect(resumed.events.single.type, EventType.TIMEOUT_END);
    });

    test('завершить чужой таймаут нельзя', () {
      final playing = _playing(_match());
      final timeout = _engine.apply(
        playing,
        StartTimeoutAction(team: playing.activeTeam),
      )!;

      expect(
        _engine.apply(
          timeout.state,
          EndTimeoutAction(team: playing.opponentTeam),
        ),
        isNull,
      );
    });

    test('халфтайм только между очками и возвращает прежний состав', () {
      final lineup = _fullLineup(_match());

      expect(
        _engine.apply(_playing(_match()), const StartHalftimeAction()),
        isNull,
      );

      final result = _engine.apply(lineup, const StartHalftimeAction())!;
      expect(result.state, isA<GameStateHalftime>());
      expect(result.events.single.type, EventType.HALFTIME_START);

      final resumed = _engine.apply(
        result.state,
        const EndHalftimeAction(),
      )!;
      expect(resumed.state, same(lineup));
      expect(resumed.events.single.type, EventType.HALFTIME_END);
    });
  });
}
