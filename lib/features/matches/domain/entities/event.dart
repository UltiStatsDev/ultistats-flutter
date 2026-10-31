// ignore_for_file: constant_identifier_names

enum EventType {
  PICKUP,
  PASS,
  INCOMPLETE_PASS,
  GOAL,
  BLOCK,
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

sealed class Event {
  final String? id;
  final int? sequenceNumber;
  final DateTime occurredAt;
  final EventType type;

  Event({
    this.id,
    this.sequenceNumber,
    DateTime? occurredAt,
    required this.type,
  }) : occurredAt = occurredAt ?? DateTime.now();
}

class MatchEvent extends Event {
  MatchEvent({
    super.id,
    super.sequenceNumber,
    super.occurredAt,
    required super.type,
  });

  MatchEvent.halftimeStart({DateTime? occurredAt})
    : this(occurredAt: occurredAt, type: EventType.HALFTIME_START);

  MatchEvent.halftimeEnd({DateTime? occurredAt})
    : this(occurredAt: occurredAt, type: EventType.HALFTIME_END);
}

class Event1 extends Event {
  final String participantId;

  Event1({
    super.id,
    super.sequenceNumber,
    super.occurredAt,
    required super.type,
    required this.participantId,
  });

  Event1.incompletePass({DateTime? occurredAt, required String participantId})
    : this(
        occurredAt: occurredAt,
        participantId: participantId,
        type: EventType.INCOMPLETE_PASS,
      );

  Event1.drop({DateTime? occurredAt, required String participantId})
    : this(
        occurredAt: occurredAt,
        participantId: participantId,
        type: EventType.DROP,
      );

  Event1.pull({DateTime? occurredAt, required String participantId})
    : this(
        occurredAt: occurredAt,
        participantId: participantId,
        type: EventType.PULL,
      );

  Event1.turnover({DateTime? occurredAt, required String participantId})
    : this(
        occurredAt: occurredAt,
        participantId: participantId,
        type: EventType.TURNOVER,
      );

  Event1.pickup({DateTime? occurredAt, required String participantId})
    : this(
        occurredAt: occurredAt,
        participantId: participantId,
        type: EventType.PICKUP,
      );
}

class Event2 extends Event1 {
  final String toParticipantId;

  Event2({
    super.id,
    super.sequenceNumber,
    required super.occurredAt,
    required super.type,
    required super.participantId,
    required this.toParticipantId,
  });

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

class TeamEvent extends Event {
  final String teamId;

  TeamEvent({
    super.id,
    super.sequenceNumber,
    super.occurredAt,
    required super.type,
    required this.teamId,
  });

  TeamEvent.timeoutStart({DateTime? occurredAt, required String teamId})
    : this(
        occurredAt: occurredAt,
        teamId: teamId,
        type: EventType.TIMEOUT_START,
      );

  TeamEvent.timeoutEnd({DateTime? occurredAt, required String teamId})
    : this(occurredAt: occurredAt, teamId: teamId, type: EventType.TIMEOUT_END);
}
