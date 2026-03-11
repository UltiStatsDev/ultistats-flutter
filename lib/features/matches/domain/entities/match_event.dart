enum MatchEventType {
  PASS,
  CATCH,
  GOAL,
  ASSIST,
  BLOCK,
  INTERCEPTION,
  DROP,
  PULL,
  BRICK,
  TIMEOUT,
  HALFTIME,
  VIOLATION,
  SAVES,
  SAVE_GOALS,
  DROPS_ON_MARKER,
  DROPS_ON_FIELD,
  CALLAHAN_DROPS,
  DISC_POSSESSIONS,
  CALLAHANS,
  UNKNOWN
}

class MatchEvent {
  final MatchEventType type;
  final DateTime timestamp;
  final String? teamId;
  final String? playerId;
  final String? toTeamId;
  final String? toPlayerId;

  const MatchEvent({
    required this.type,
    required this.timestamp,
    this.teamId,
    this.playerId,
    this.toTeamId,
    this.toPlayerId,
  });
}
