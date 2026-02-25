// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) => MatchModel(
  id: json['id'] as String,
  teams: (json['teams'] as List<dynamic>)
      .map((e) => TeamModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  eventCount: (json['eventCount'] as num).toInt(),
  diskHolderId: json['diskHolderId'] as String?,
);

Map<String, dynamic> _$MatchModelToJson(MatchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teams': instance.teams.map((e) => e.toJson()).toList(),
      'eventCount': instance.eventCount,
      'diskHolderId': instance.diskHolderId,
    };
