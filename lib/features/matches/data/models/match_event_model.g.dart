// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchEventModel _$MatchEventModelFromJson(Map<String, dynamic> json) =>
    MatchEventModel(
      type: $enumDecode(_$MatchEventTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      team: json['team'] as String?,
      player: json['player'] as String?,
      fromTeam: json['fromTeam'] as String?,
      fromPlayer: json['fromPlayer'] as String?,
      toTeam: json['toTeam'] as String?,
      toPlayer: json['toPlayer'] as String?,
    );

Map<String, dynamic> _$MatchEventModelToJson(MatchEventModel instance) =>
    <String, dynamic>{
      'type': _$MatchEventTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'team': instance.team,
      'player': instance.player,
      'fromTeam': instance.fromTeam,
      'fromPlayer': instance.fromPlayer,
      'toTeam': instance.toTeam,
      'toPlayer': instance.toPlayer,
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
