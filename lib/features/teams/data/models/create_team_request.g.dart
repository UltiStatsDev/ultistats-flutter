// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_team_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTeamRequest _$CreateTeamRequestFromJson(Map<String, dynamic> json) =>
    CreateTeamRequest(
      name: json['name'] as String,
      playerIds: (json['playerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CreateTeamRequestToJson(CreateTeamRequest instance) =>
    <String, dynamic>{'name': instance.name, 'playerIds': instance.playerIds};
