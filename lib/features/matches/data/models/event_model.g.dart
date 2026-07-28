// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
  occurredAt: DateTime.parse(json['occurredAt'] as String),
  sequenceNumber: (json['sequenceNumber'] as num).toInt(),
  id: json['id'] as String,
  type: $enumDecodeNullable(_$EventTypeEnumMap, json['type']),
);

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'occurredAt': instance.occurredAt.toIso8601String(),
      'sequenceNumber': instance.sequenceNumber,
      'id': instance.id,
      'type': _$EventTypeEnumMap[instance.type],
    };

const _$EventTypeEnumMap = {
  EventType.PASS: 'PASS',
  EventType.GOAL: 'GOAL',
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
