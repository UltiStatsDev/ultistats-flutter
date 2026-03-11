// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_filter_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamFilterRequest _$TeamFilterRequestFromJson(Map<String, dynamic> json) =>
    TeamFilterRequest(
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      sort: json['sort'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$TeamFilterRequestToJson(TeamFilterRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'sort': ?instance.sort,
      'name': ?instance.name,
    };
