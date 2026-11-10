// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
  id: json['id'] as String,
  login: json['login'] as String,
  displayName: json['displayName'] as String,
  role: json['role'] as String,
  status: json['status'] as String,
  mustChangePassword: json['mustChangePassword'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'displayName': instance.displayName,
      'role': instance.role,
      'status': instance.status,
      'mustChangePassword': instance.mustChangePassword,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
