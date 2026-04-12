// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamListItemModel _$TeamListItemModelFromJson(Map<String, dynamic> json) =>
    TeamListItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      city: json['city'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$TeamListItemModelToJson(TeamListItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'photoUrl': instance.photoUrl,
    };
