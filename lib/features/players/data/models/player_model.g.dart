// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) => PlayerModel(
  id: json['id'] as String,
  teamId: json['teamId'] as String?,
  number: (json['number'] as num?)?.toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
);

Map<String, dynamic> _$PlayerModelToJson(PlayerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'number': instance.number,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };
