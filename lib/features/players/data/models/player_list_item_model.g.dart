// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerListItemModel _$PlayerListItemModelFromJson(Map<String, dynamic> json) =>
    PlayerListItemModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$PlayerListItemModelToJson(
  PlayerListItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'photoUrl': instance.photoUrl,
};
