// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_filter_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchFilterRequest _$MatchFilterRequestFromJson(Map<String, dynamic> json) =>
    MatchFilterRequest(
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      sort: json['sort'] as String?,
      teamId: json['teamId'] as String?,
      status: json['status'] as String?,
      dateFrom: json['dateFrom'] as String?,
      dateTo: json['dateTo'] as String?,
    );

Map<String, dynamic> _$MatchFilterRequestToJson(MatchFilterRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'sort': ?instance.sort,
      'teamId': ?instance.teamId,
      'status': ?instance.status,
      'dateFrom': ?instance.dateFrom,
      'dateTo': ?instance.dateTo,
    };
