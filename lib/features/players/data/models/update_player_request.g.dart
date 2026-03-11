// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_player_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePlayerRequest _$UpdatePlayerRequestFromJson(Map<String, dynamic> json) =>
    UpdatePlayerRequest(
      number: (json['number'] as num?)?.toInt(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      teamId: json['teamId'] as String?,
    );

Map<String, dynamic> _$UpdatePlayerRequestToJson(
  UpdatePlayerRequest instance,
) => <String, dynamic>{
  'number': ?instance.number,
  'firstName': ?instance.firstName,
  'lastName': ?instance.lastName,
  'teamId': ?instance.teamId,
};
