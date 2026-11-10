enum AccountRole {
  organizer('ORGANIZER', 'Организатор'),
  admin('ADMIN', 'Администратор');

  const AccountRole(this.wireName, this.label);

  final String wireName;
  final String label;

  static AccountRole fromWire(String value) {
    for (final role in values) {
      if (role.wireName == value) return role;
    }
    return AccountRole.organizer;
  }
}

enum AccountStatus {
  active('ACTIVE'),
  blocked('BLOCKED');

  const AccountStatus(this.wireName);

  final String wireName;

  static AccountStatus fromWire(String value) {
    for (final status in values) {
      if (status.wireName == value) return status;
    }
    return AccountStatus.active;
  }
}

class Account {
  const Account({
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
  final AccountRole role;
  final AccountStatus status;
  final bool mustChangePassword;
  final DateTime createdAt;
  final DateTime updatedAt;
}
