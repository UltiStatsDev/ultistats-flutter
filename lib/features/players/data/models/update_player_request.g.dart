// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_player_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePlayerRequest _$UpdatePlayerRequestFromJson(Map<String, dynamic> json) =>
    UpdatePlayerRequest(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );

Map<String, dynamic> _$UpdatePlayerRequestToJson(
  UpdatePlayerRequest instance,
) => <String, dynamic>{
  'firstName': ?instance.firstName,
  'lastName': ?instance.lastName,
};
