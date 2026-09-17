// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchTeamModel _$MatchTeamModelFromJson(Map<String, dynamic> json) =>
    MatchTeamModel(
      teamId: json['teamId'] as String,
      teamName: json['teamName'] as String,
      teamScore: (json['teamScore'] as num).toInt(),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => MatchParticipantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      city: json['city'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$MatchTeamModelToJson(MatchTeamModel instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'teamName': instance.teamName,
      'teamScore': instance.teamScore,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'city': instance.city,
      'photoUrl': instance.photoUrl,
    };
