// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_filter_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerFilterRequest _$PlayerFilterRequestFromJson(Map<String, dynamic> json) =>
    PlayerFilterRequest(
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      sort: json['sort'] as String?,
      name: json['name'] as String?,
      teamId: json['teamId'] as String?,
    );

Map<String, dynamic> _$PlayerFilterRequestToJson(
  PlayerFilterRequest instance,
) => <String, dynamic>{
  'page': instance.page,
  'size': instance.size,
  'sort': ?instance.sort,
  'name': ?instance.name,
  'teamId': ?instance.teamId,
};
