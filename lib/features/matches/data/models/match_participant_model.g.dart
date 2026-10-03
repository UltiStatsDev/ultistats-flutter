// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchParticipantModel _$MatchParticipantModelFromJson(
  Map<String, dynamic> json,
) => MatchParticipantModel(
  participantId: json['participantId'] as String,
  kind: json['kind'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  displayName: json['displayName'] as String,
  number: (json['number'] as num?)?.toInt(),
  photoUrl: json['photoUrl'] as String?,
);

Map<String, dynamic> _$MatchParticipantModelToJson(
  MatchParticipantModel instance,
) => <String, dynamic>{
  'participantId': instance.participantId,
  'kind': instance.kind,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'displayName': instance.displayName,
  'photoUrl': instance.photoUrl,
  'number': instance.number,
};
