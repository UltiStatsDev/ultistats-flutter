// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_player_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePlayerRequest _$CreatePlayerRequestFromJson(Map<String, dynamic> json) =>
    CreatePlayerRequest(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );

Map<String, dynamic> _$CreatePlayerRequestToJson(
  CreatePlayerRequest instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
};
