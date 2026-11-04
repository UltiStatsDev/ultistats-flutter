import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';

/// Намерение пользователя, которое переводит игру из одного состояния в другое.
///
/// UI не меняет состояние напрямую: он создаёт действие и отдаёт его
/// `MatchGameNotifier.dispatch`. Перевод состояния и набор событий для сервера
/// вычисляет [MatchGameEngine] — это чистая доменная логика.
sealed class MatchAction {
  const MatchAction();
}

class TogglePlayerAction extends MatchAction {
  const TogglePlayerAction({
    required this.participantId,
    required this.teamIndex,
  });

  final String participantId;
  final int teamIndex;
}

class ConfirmLineupAction extends MatchAction {
  const ConfirmLineupAction({required this.pullingTeamId});

  final String pullingTeamId;
}

class SelectPullerAction extends MatchAction {
  const SelectPullerAction(this.puller);

  final MatchParticipant puller;
}

class SelectTakerAction extends MatchAction {
  const SelectTakerAction(this.taker);

  final MatchParticipant taker;
}

class PassToAction extends MatchAction {
  const PassToAction(this.receiver);

  final MatchParticipant receiver;
}

class DeclareTurnoverAction extends MatchAction {
  const DeclareTurnoverAction();
}

class ScoreGoalAction extends MatchAction {
  const ScoreGoalAction(this.scorer);

  final MatchParticipant scorer;
}

class StartTimeoutAction extends MatchAction {
  const StartTimeoutAction({required this.team});

  final MatchTeam team;
}

class EndTimeoutAction extends MatchAction {
  const EndTimeoutAction({required this.team});

  final MatchTeam team;
}

class StartHalftimeAction extends MatchAction {
  const StartHalftimeAction();
}

class EndHalftimeAction extends MatchAction {
  const EndHalftimeAction();
}

/// Отмена последнего действия.
///
/// Движок это действие не обрабатывает: откат состояния и удаление последнего
/// события на сервере выполняет `MatchGameNotifier`.
class UndoLastAction extends MatchAction {
  const UndoLastAction();
}
