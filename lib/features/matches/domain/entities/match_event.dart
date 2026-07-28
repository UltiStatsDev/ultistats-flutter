enum EventType {
  PASS,
  GOAL,
  DROP,
  PULL,
  BRICK,
  TURNOVER,
  BLOCK_MARKER,
  BLOCK_FIELD,
  INTERCEPTION,
  CALLAHAN,
  TIMEOUT_START,
  TIMEOUT_END,
  HALFTIME_START,
  HALFTIME_END,
  UNKNOWN,
}

class Event {
  final DateTime occurredAt;
  final int sequenceNumber;
  final String id;
  final EventType? type;

  const Event({
    required this.occurredAt,
    required this.sequenceNumber,
    required this.id,
    this.type,
  });
}
