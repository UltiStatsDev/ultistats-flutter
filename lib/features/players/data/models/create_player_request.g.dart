// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_player_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePlayerRequest _$CreatePlayerRequestFromJson(Map<String, dynamic> json) =>
    CreatePlayerRequest(
      number: (json['number'] as num).toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      teamId: json['teamId'] as String,
    );

Map<String, dynamic> _$CreatePlayerRequestToJson(
  CreatePlayerRequest instance,
) => <String, dynamic>{
  'number': instance.number,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'teamId': instance.teamId,
};
