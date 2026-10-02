import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';

part 'event_model.g.dart';

@JsonSerializable(createFactory: false)
class EventModel {
  final DateTime occurredAt;
  final String? participantId;
  final String? toParticipantId;
  final String? teamId;
  final EventType type;

  const EventModel({
    required this.occurredAt,
    this.participantId,
    this.toParticipantId,
    this.teamId,
    required this.type,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final type = $enumDecode(_$EventTypeEnumMap, json['type']);

    return EventModel(
      occurredAt: DateTime.parse(json['occurredAt'] as String).toLocal(),
      type: type,
      teamId: json['teamId'] as String?,
      participantId:
          (json['fromParticipantId'] ?? json['participantId']) as String?,
      toParticipantId: json['toParticipantId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'occurredAt': occurredAt.toUtc().toIso8601String(),
      'type': _$EventTypeEnumMap[type],
    };

    if (teamId != null) {
      json['teamId'] = teamId;
    } else if (toParticipantId != null) {
      json['fromParticipantId'] = participantId;
      json['toParticipantId'] = toParticipantId;
    } else if (participantId != null) {
      json['participantId'] = participantId;
    }

    return json;
  }

  factory EventModel.fromEntity(Event event) {
    return switch (event) {
      MatchEvent e => EventModel(occurredAt: e.occurredAt, type: e.type),
      TeamEvent e => EventModel(
        occurredAt: e.occurredAt,
        type: e.type,
        teamId: e.teamId,
      ),
      Event2 e => EventModel(
        occurredAt: e.occurredAt,
        type: e.type,
        participantId: e.participantId,
        toParticipantId: e.toParticipantId,
      ),
      Event1 e => EventModel(
        occurredAt: e.occurredAt,
        type: e.type,
        participantId: e.participantId,
      ),
    };
  }

  Event toEntity() {
    if (teamId != null) {
      return TeamEvent(occurredAt: occurredAt, type: type, teamId: teamId!);
    }
    if (toParticipantId != null) {
      return Event2(
        occurredAt: occurredAt,
        type: type,
        participantId: participantId!,
        toParticipantId: toParticipantId!,
      );
    }
    if (participantId != null) {
      return Event1(occurredAt: occurredAt, type: type, participantId: participantId!);
    }

    return MatchEvent(occurredAt: occurredAt, type: type);
  }
}
