// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamPlayerModel _$TeamPlayerModelFromJson(Map<String, dynamic> json) =>
    TeamPlayerModel(
      teamId: json['teamId'] as String,
      playerId: json['playerId'] as String,
      number: (json['number'] as num?)?.toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$TeamPlayerModelToJson(TeamPlayerModel instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'playerId': instance.playerId,
      'number': instance.number,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'photoUrl': instance.photoUrl,
    };
