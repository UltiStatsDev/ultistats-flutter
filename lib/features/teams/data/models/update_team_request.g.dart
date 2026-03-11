// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_team_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTeamRequest _$UpdateTeamRequestFromJson(Map<String, dynamic> json) =>
    UpdateTeamRequest(
      name: json['name'] as String?,
      playerIds: (json['playerIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UpdateTeamRequestToJson(UpdateTeamRequest instance) =>
    <String, dynamic>{'name': ?instance.name, 'playerIds': ?instance.playerIds};
