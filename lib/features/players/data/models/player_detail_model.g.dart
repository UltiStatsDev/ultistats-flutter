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
      memberships: (json['memberships'] as List<dynamic>)
          .map((e) => PlayerMembershipModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$PlayerDetailModelToJson(PlayerDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'photoUrl': instance.photoUrl,
      'memberships': instance.memberships.map((e) => e.toJson()).toList(),
    };
