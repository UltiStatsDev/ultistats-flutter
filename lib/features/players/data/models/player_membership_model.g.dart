// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_membership_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerMembershipModel _$PlayerMembershipModelFromJson(
  Map<String, dynamic> json,
) => PlayerMembershipModel(
  teamId: json['teamId'] as String,
  teamName: json['teamName'] as String,
  playerId: json['playerId'] as String,
  number: (json['number'] as num).toInt(),
);

Map<String, dynamic> _$PlayerMembershipModelToJson(
  PlayerMembershipModel instance,
) => <String, dynamic>{
  'teamId': instance.teamId,
  'teamName': instance.teamName,
  'playerId': instance.playerId,
  'number': instance.number,
};
