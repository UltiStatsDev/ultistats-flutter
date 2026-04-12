// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerDetailModel _$PlayerDetailModelFromJson(Map<String, dynamic> json) =>
    PlayerDetailModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      team: json['team'] == null
          ? null
          : TeamListItemModel.fromJson(json['team'] as Map<String, dynamic>),
      number: (json['number'] as num?)?.toInt(),
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$PlayerDetailModelToJson(PlayerDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'team': instance.team?.toJson(),
      'number': instance.number,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'photoUrl': instance.photoUrl,
    };
