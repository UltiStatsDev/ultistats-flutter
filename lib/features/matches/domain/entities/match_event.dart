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
  final String participantId;
  final EventType? type;

  // Главный конструктор. Если occurredAt не передан, берем текущее время.
  Event({
    DateTime? occurredAt,
    required this.participantId,
    this.type,
  }) : occurredAt = occurredAt ?? DateTime.now();

  // Именованные конструкторы для основных игровых действий
  Event.pass({DateTime? occurredAt, required String participantId})
      : this(
    occurredAt: occurredAt,
    participantId: participantId,
    type: EventType.PASS,
  );

  Event.goal({DateTime? occurredAt, required String participantId})
      : this(
    occurredAt: occurredAt,
    participantId: participantId,
    type: EventType.GOAL,
  );

  Event.drop({DateTime? occurredAt, required String participantId})
      : this(
    occurredAt: occurredAt,
    participantId: participantId,
    type: EventType.DROP,
  );

  Event.pull({DateTime? occurredAt, required String participantId})
      : this(
    occurredAt: occurredAt,
    participantId: participantId,
    type: EventType.PULL,
  );

  Event.turnover({DateTime? occurredAt, required String participantId})
      : this(
    occurredAt: occurredAt,
    participantId: participantId,
    type: EventType.TURNOVER,
  );

  Event.block({DateTime? occurredAt, required String participantId})
      : this(
    occurredAt: occurredAt,
    participantId: participantId,
    type: EventType.BLOCK_FIELD,
  );
}