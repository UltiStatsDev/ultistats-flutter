import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/auth/data/models/account_model.dart';
import 'package:ultistats/features/auth/domain/entities/auth_permission.dart';
import 'package:ultistats/features/auth/domain/entities/auth_session.dart';

part 'auth_context_model.g.dart';

@JsonSerializable()
class AuthContextModel {
  const AuthContextModel({
    required this.contractVersion,
    required this.installationId,
    required this.serverNow,
    required this.state,
    required this.sessionId,
    required this.account,
    required this.permissions,
    required this.lastActivityAt,
    required this.idleExpiresAt,
    required this.reauthenticatedUntil,
    required this.replacedSessionId,
  });

  final String contractVersion;
  final String installationId;
  final DateTime serverNow;
  final String state;
  final String? sessionId;
  final AccountModel? account;
  final List<String> permissions;
  final DateTime? lastActivityAt;
  final DateTime? idleExpiresAt;
  final DateTime? reauthenticatedUntil;
  final String? replacedSessionId;

  factory AuthContextModel.fromJson(Map<String, dynamic> json) =>
      _$AuthContextModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthContextModelToJson(this);

  AuthSession toEntity() {
    return AuthSession(
      status: switch (state) {
        'AUTHENTICATED' => AuthStatus.authenticated,
        'PASSWORD_CHANGE_REQUIRED' => AuthStatus.passwordChangeRequired,
        _ => AuthStatus.anonymous,
      },
      installationId: installationId,
      sessionId: sessionId,
      account: account?.toEntity(),
      permissions: permissions
          .map(AuthPermission.fromWire)
          .whereType<AuthPermission>()
          .toSet(),
      lastActivityAt: lastActivityAt,
      idleExpiresAt: idleExpiresAt,
      reauthenticatedUntil: reauthenticatedUntil,
      replacedSessionId: replacedSessionId,
    );
  }
}
