import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/event.dart';

part 'event_model.g.dart';

@JsonSerializable(createFactory: false)
class EventModel {
  final DateTime occurredAt;
  final String participantId;
  final String? toParticipantId;
  final EventType? type;

  const EventModel({
    required this.occurredAt,
    required this.participantId,
    this.toParticipantId,
    this.type,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // Используем сгенерированную карту для енамов, если она доступна
    final type = $enumDecodeNullable(_$EventTypeEnumMap, json['type']);

    return EventModel(
      occurredAt: DateTime.parse(json['occurredAt'] as String).toLocal(),
      participantId: (json['fromParticipantId'] ?? json['participantId']) as String,
      toParticipantId: json['toParticipantId'] as String?,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'occurredAt': occurredAt.toIso8601String(),
      'type': _$EventTypeEnumMap[type],
    };

    if (toParticipantId != null) {
      // Логика для Event2
      json['fromParticipantId'] = participantId;
      json['toParticipantId'] = toParticipantId!;
    } else {
      // Логика для обычного Event
      json['participantId'] = participantId;
    }
    return json;
  }

  factory EventModel.fromEntity(Event event) {
    return EventModel(
      occurredAt: event.occurredAt.toUtc(),
      participantId: event.participantId,
      type: event.type,
      toParticipantId: event is Event2 ? event.toParticipantId : null,
    );
  }

  Event toEntity() {
    if (toParticipantId != null) {
      return Event2(
        occurredAt: occurredAt,
        participantId: participantId,
        toParticipantId: toParticipantId!,
        type: type,
      );
    }

    return Event(
      type: type,
      participantId: participantId,
      occurredAt: occurredAt,
    );
  }
}
