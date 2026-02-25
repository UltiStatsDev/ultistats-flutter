// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamModel _$TeamModelFromJson(Map<String, dynamic> json) => TeamModel(
  id: json['id'] as String,
  name: json['name'] as String,
  players: (json['players'] as List<dynamic>)
      .map((e) => PlayerModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TeamModelToJson(TeamModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'players': instance.players.map((e) => e.toJson()).toList(),
};
