import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';

/// Намерение пользователя, которое переводит игру из одного состояния в другое.
///
/// UI не меняет состояние напрямую: он создаёт действие и отдаёт его
/// `MatchGameNotifier.dispatch`. Перевод состояния и набор событий для сервера
/// вычисляет [MatchGameEngine] — это чистая доменная логика.
sealed class MatchAction {
  const MatchAction();

  /// Можно ли отменить действие кнопкой отмены.
  ///
  /// Выбор игроков состава — черновик: его можно переключать сколько угодно до
  /// подтверждения, поэтому он не занимает слот отмены и не сбрасывает его.
  /// Остальные действия, включая подтверждение состава и пулл, отменяются.
  bool get isUndoable => true;
}

class TogglePlayerAction extends MatchAction {
  const TogglePlayerAction({
    required this.participantId,
    required this.teamIndex,
  });

  final String participantId;
  final int teamIndex;

  @override
  bool get isUndoable => false;
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

/// Игрок с диском не завершил бросок: throwaway, выход в аут или
/// потерянная ловля. Событие INCOMPLETE_PASS записывается бросающему.
class ThrowAwayAction extends MatchAction {
  const ThrowAwayAction();
}

/// Вид блока: без уточнения, блок маркером или блок полевым защитником.
enum BlockKind { unspecified, marker, field }

/// Защитник заблокировал бросок соперника.
class BlockAction extends MatchAction {
  const BlockAction({
    required this.blocker,
    this.kind = BlockKind.unspecified,
  });

  final MatchParticipant blocker;
  final BlockKind kind;
}

/// Защитник поймал пас соперника и сразу получил владение.
class InterceptionAction extends MatchAction {
  const InterceptionAction(this.interceptor);

  final MatchParticipant interceptor;
}

/// Защитник перехватил пас в голевой зоне и завершил поинт.
class CallahanAction extends MatchAction {
  const CallahanAction(this.interceptor);

  final MatchParticipant interceptor;
}

/// Объявление brick для пулла, который только что выполнялся.
class DeclareBrickAction extends MatchAction {
  const DeclareBrickAction();
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

  @override
  bool get isUndoable => false;
}
