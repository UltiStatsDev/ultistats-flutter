// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchListItemModel _$MatchListItemModelFromJson(Map<String, dynamic> json) =>
    MatchListItemModel(
      id: json['id'] as String,
      teams: (json['teams'] as List<dynamic>)
          .map((e) => MatchListTeamModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      plannedStartTimestamp: json['plannedStartTimestamp'] == null
          ? null
          : DateTime.parse(json['plannedStartTimestamp'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      status: $enumDecode(_$MatchStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$MatchListItemModelToJson(
  MatchListItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'teams': instance.teams,
  'plannedStartTimestamp': instance.plannedStartTimestamp?.toIso8601String(),
  'startedAt': instance.startedAt?.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'status': _$MatchStatusEnumMap[instance.status]!,
};

const _$MatchStatusEnumMap = {
  MatchStatus.planned: 'planned',
  MatchStatus.inProgress: 'inProgress',
  MatchStatus.finished: 'finished',
};

MatchListTeamModel _$MatchListTeamModelFromJson(Map<String, dynamic> json) =>
    MatchListTeamModel(
      teamId: json['teamId'] as String,
      teamName: json['teamName'] as String,
      teamScore: (json['teamScore'] as num).toInt(),
      playerIds: (json['playerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      city: json['city'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$MatchListTeamModelToJson(MatchListTeamModel instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'teamName': instance.teamName,
      'teamScore': instance.teamScore,
      'playerIds': instance.playerIds,
      'city': instance.city,
      'photoUrl': instance.photoUrl,
    };
