// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_match_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMatchRequest _$UpdateMatchRequestFromJson(Map<String, dynamic> json) =>
    UpdateMatchRequest(
      teamIds: (json['teamIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      playersPerTeam: (json['playersPerTeam'] as num?)?.toInt(),
      plannedStartTimestamp: json['plannedStartTimestamp'] as String?,
    );

Map<String, dynamic> _$UpdateMatchRequestToJson(UpdateMatchRequest instance) =>
    <String, dynamic>{
      'teamIds': ?instance.teamIds,
      'plannedStartTimestamp': ?instance.plannedStartTimestamp,
      'playersPerTeam': ?instance.playersPerTeam,
    };
