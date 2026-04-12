// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamDetailModel _$TeamDetailModelFromJson(Map<String, dynamic> json) =>
    TeamDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      players: (json['players'] as List<dynamic>)
          .map((e) => PlayerListItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      city: json['city'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$TeamDetailModelToJson(TeamDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'players': instance.players.map((e) => e.toJson()).toList(),
      'city': instance.city,
      'photoUrl': instance.photoUrl,
    };
