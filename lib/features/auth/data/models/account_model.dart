import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/auth/domain/entities/account.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  const AccountModel({
    required this.id,
    required this.login,
    required this.displayName,
    required this.role,
    required this.status,
    required this.mustChangePassword,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String login;
  final String displayName;
  final String role;
  final String status;
  final bool mustChangePassword;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);

  Account toEntity() {
    return Account(
      id: id,
      login: login,
      displayName: displayName,
      role: AccountRole.fromWire(role),
      status: AccountStatus.fromWire(status),
      mustChangePassword: mustChangePassword,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
