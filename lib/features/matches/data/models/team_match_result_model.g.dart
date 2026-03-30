// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_match_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamMatchResultModel _$TeamMatchResultModelFromJson(
  Map<String, dynamic> json,
) => TeamMatchResultModel(
  teamId: json['teamId'] as String,
  teamName: json['teamName'] as String,
  teamScore: (json['teamScore'] as num).toInt(),
  playerIds: (json['playerIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  city: json['city'] as String?,
  photoUrl: json['photoUrl'] as String?,
);

Map<String, dynamic> _$TeamMatchResultModelToJson(
  TeamMatchResultModel instance,
) => <String, dynamic>{
  'teamId': instance.teamId,
  'teamName': instance.teamName,
  'teamScore': instance.teamScore,
  'playerIds': instance.playerIds,
  'city': instance.city,
  'photoUrl': instance.photoUrl,
};
