// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateEventRequest _$CreateEventRequestFromJson(Map<String, dynamic> json) =>
    CreateEventRequest(
      type: $enumDecode(_$MatchEventTypeEnumMap, json['type']),
      timestamp: json['timestamp'] as String,
      teamId: json['teamId'] as String?,
      playerId: json['playerId'] as String?,
      toTeamId: json['toTeamId'] as String?,
      toPlayerId: json['toPlayerId'] as String?,
    );

Map<String, dynamic> _$CreateEventRequestToJson(CreateEventRequest instance) =>
    <String, dynamic>{
      'type': _$MatchEventTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp,
      'teamId': ?instance.teamId,
      'playerId': ?instance.playerId,
      'toTeamId': ?instance.toTeamId,
      'toPlayerId': ?instance.toPlayerId,
    };

const _$MatchEventTypeEnumMap = {
  MatchEventType.PASS: 'PASS',
  MatchEventType.CATCH: 'CATCH',
  MatchEventType.GOAL: 'GOAL',
  MatchEventType.ASSIST: 'ASSIST',
  MatchEventType.BLOCK: 'BLOCK',
  MatchEventType.INTERCEPTION: 'INTERCEPTION',
  MatchEventType.DROP: 'DROP',
  MatchEventType.PULL: 'PULL',
  MatchEventType.BRICK: 'BRICK',
  MatchEventType.TIMEOUT: 'TIMEOUT',
  MatchEventType.HALFTIME: 'HALFTIME',
  MatchEventType.VIOLATION: 'VIOLATION',
  MatchEventType.SAVES: 'SAVES',
  MatchEventType.SAVE_GOALS: 'SAVE_GOALS',
  MatchEventType.DROPS_ON_MARKER: 'DROPS_ON_MARKER',
  MatchEventType.DROPS_ON_FIELD: 'DROPS_ON_FIELD',
  MatchEventType.CALLAHAN_DROPS: 'CALLAHAN_DROPS',
  MatchEventType.DISC_POSSESSIONS: 'DISC_POSSESSIONS',
  MatchEventType.CALLAHANS: 'CALLAHANS',
  MatchEventType.UNKNOWN: 'UNKNOWN',
};
