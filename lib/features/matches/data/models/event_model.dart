import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/match_event.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  final DateTime occurredAt;
  final int sequenceNumber;
  final String id;
  final EventType? type;

  const EventModel({
    required this.occurredAt,
    required this.sequenceNumber,
    required this.id,
    this.type,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  Event toEntity() {
    return Event(
      type: type,
      id: id,
      occurredAt: occurredAt,
      sequenceNumber: sequenceNumber
    );
  }
}
