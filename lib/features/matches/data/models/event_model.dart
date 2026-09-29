import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/match_event.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  final DateTime occurredAt;
  final String participantId;
  final EventType? type;

  const EventModel({
    required this.occurredAt,
    required this.participantId,
    this.type,
  });

  factory EventModel.fromEntity(Event event) {
    return EventModel(
      occurredAt: event.occurredAt,
      participantId: event.participantId,
      type: event.type,
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  Event toEntity() {
    return Event(
      type: type,
      participantId: participantId,
      occurredAt: occurredAt,
    );
  }
}
