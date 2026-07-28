// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateEventRequest _$UpdateEventRequestFromJson(Map<String, dynamic> json) =>
    UpdateEventRequest(type: $enumDecode(_$EventTypeEnumMap, json['type']));

Map<String, dynamic> _$UpdateEventRequestToJson(UpdateEventRequest instance) =>
    <String, dynamic>{'type': _$EventTypeEnumMap[instance.type]!};

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
