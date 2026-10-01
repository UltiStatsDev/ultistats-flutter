enum EventType {
  PICKUP,
  PASS, //
  INCOMPLETE_PASS,
  GOAL, //
  BLOCK, //
  DROP,
  PULL,
  BRICK,
  TURNOVER,
  BLOCK_MARKER, //
  BLOCK_FIELD, //
  INTERCEPTION, //
  CALLAHAN, //
  TIMEOUT_START,
  TIMEOUT_END,
  HALFTIME_START,
  HALFTIME_END,
  UNKNOWN,
}

// два челика
// PASS, GOAL, BLOCK, BLOCK_MARKER, BLOCK_FIELD, INTERCEPTION или CALLAHAN.

class Event {
  final DateTime occurredAt;
  final String participantId;
  final EventType? type;

  Event({DateTime? occurredAt, required this.participantId, this.type})
    : occurredAt = occurredAt ?? DateTime.now();

  Event.incompletePass({DateTime? occurredAt, required String participantId})
    : this(
        occurredAt: occurredAt,
        participantId: participantId,
        type: EventType.INCOMPLETE_PASS,
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

  Event.pickup({DateTime? occurredAt, required String participantId})
    : this(
        occurredAt: occurredAt,
        participantId: participantId,
        type: EventType.PICKUP,
      );
}

/// поле [participantId] в [Event2] при создании json будет названо [fromParticipantId]
class Event2 extends Event {
  Event2({
    DateTime? occurredAt,
    required super.participantId,
    super.type,
    required this.toParticipantId,
  });

  final String toParticipantId;

  Event2.goal({
    DateTime? occurredAt,
    required String participantId,
    required String toParticipantId,
  }) : this(
         occurredAt: occurredAt,
         participantId: participantId,
         toParticipantId: toParticipantId,
         type: EventType.GOAL,
       );

  Event2.pass({
    DateTime? occurredAt,
    required String participantId,
    required String toParticipantId,
  }) : this(
    occurredAt: occurredAt,
    participantId: participantId,
    toParticipantId: toParticipantId,
    type: EventType.PASS,
  );

  Event2.block({
    DateTime? occurredAt,
    required String participantId,
    required String toParticipantId,
  }) : this(
    occurredAt: occurredAt,
    participantId: participantId,
    toParticipantId: toParticipantId,
    type: EventType.BLOCK,
  );
}
