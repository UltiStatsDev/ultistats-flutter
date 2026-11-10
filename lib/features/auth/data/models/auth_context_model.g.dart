// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_context_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthContextModel _$AuthContextModelFromJson(Map<String, dynamic> json) =>
    AuthContextModel(
      contractVersion: json['contractVersion'] as String,
      installationId: json['installationId'] as String,
      serverNow: DateTime.parse(json['serverNow'] as String),
      state: json['state'] as String,
      sessionId: json['sessionId'] as String?,
      account: json['account'] == null
          ? null
          : AccountModel.fromJson(json['account'] as Map<String, dynamic>),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastActivityAt: json['lastActivityAt'] == null
          ? null
          : DateTime.parse(json['lastActivityAt'] as String),
      idleExpiresAt: json['idleExpiresAt'] == null
          ? null
          : DateTime.parse(json['idleExpiresAt'] as String),
      reauthenticatedUntil: json['reauthenticatedUntil'] == null
          ? null
          : DateTime.parse(json['reauthenticatedUntil'] as String),
      replacedSessionId: json['replacedSessionId'] as String?,
    );

Map<String, dynamic> _$AuthContextModelToJson(AuthContextModel instance) =>
    <String, dynamic>{
      'contractVersion': instance.contractVersion,
      'installationId': instance.installationId,
      'serverNow': instance.serverNow.toIso8601String(),
      'state': instance.state,
      'sessionId': instance.sessionId,
      'account': instance.account,
      'permissions': instance.permissions,
      'lastActivityAt': instance.lastActivityAt?.toIso8601String(),
      'idleExpiresAt': instance.idleExpiresAt?.toIso8601String(),
      'reauthenticatedUntil': instance.reauthenticatedUntil?.toIso8601String(),
      'replacedSessionId': instance.replacedSessionId,
    };
