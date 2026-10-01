// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'occurredAt': instance.occurredAt.toIso8601String(),
      'participantId': instance.participantId,
      'toParticipantId': instance.toParticipantId,
      'type': _$EventTypeEnumMap[instance.type],
    };

const _$EventTypeEnumMap = {
  EventType.PICKUP: 'PICKUP',
  EventType.PASS: 'PASS',
  EventType.INCOMPLETE_PASS: 'INCOMPLETE_PASS',
  EventType.GOAL: 'GOAL',
  EventType.BLOCK: 'BLOCK',
  EventType.DROP: 'DROP',
  EventType.PULL: 'PULL',
  EventType.BRICK: 'BRICK',
  EventType.TURNOVER: 'TURNOVER',
  EventType.BLOCK_MARKER: 'BLOCK_MARKER',
  EventType.BLOCK_FIELD: 'BLOCK_FIELD',
  EventType.INTERCEPTION: 'INTERCEPTION',
  EventType.CALLAHAN: 'CALLAHAN',
  EventType.TIMEOUT_START: 'TIMEOUT_START',
  EventType.TIMEOUT_END: 'TIMEOUT_END',
  EventType.HALFTIME_START: 'HALFTIME_START',
  EventType.HALFTIME_END: 'HALFTIME_END',
  EventType.UNKNOWN: 'UNKNOWN',
};
