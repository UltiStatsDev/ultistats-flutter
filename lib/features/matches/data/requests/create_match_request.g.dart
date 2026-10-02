// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_match_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateMatchRequest _$CreateMatchRequestFromJson(Map<String, dynamic> json) =>
    CreateMatchRequest(
      teamIds: (json['teamIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      playersPerTeam: (json['playersPerTeam'] as num).toInt(),
      plannedStartTimestamp: json['plannedStartTimestamp'] as String?,
    );

Map<String, dynamic> _$CreateMatchRequestToJson(CreateMatchRequest instance) =>
    <String, dynamic>{
      'teamIds': instance.teamIds,
      'plannedStartTimestamp': ?instance.plannedStartTimestamp,
      'playersPerTeam': instance.playersPerTeam,
    };
