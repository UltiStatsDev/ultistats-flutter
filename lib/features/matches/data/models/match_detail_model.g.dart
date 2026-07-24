// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchDetailModel _$MatchDetailModelFromJson(Map<String, dynamic> json) =>
    MatchDetailModel(
      id: json['id'] as String,
      teams: (json['teams'] as List<dynamic>)
          .map((e) => TeamMatchResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      eventCount: (json['eventCount'] as num).toInt(),
      status: json['status'] as String,
      diskHolderId: json['diskHolderId'] as String?,
      plannedStartTimestamp: json['plannedStartTimestamp'] == null
          ? null
          : DateTime.parse(json['plannedStartTimestamp'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
    );

Map<String, dynamic> _$MatchDetailModelToJson(
  MatchDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'teams': instance.teams.map((e) => e.toJson()).toList(),
  'eventCount': instance.eventCount,
  'diskHolderId': instance.diskHolderId,
  'plannedStartTimestamp': instance.plannedStartTimestamp?.toIso8601String(),
  'startedAt': instance.startedAt?.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'status': instance.status,
};
