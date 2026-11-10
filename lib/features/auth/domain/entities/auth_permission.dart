/// Права, которые сервер выдаёт вместе с сессией.
///
/// Сервер остаётся источником истины: клиентские проверки нужны только для
/// того, чтобы не показывать заведомо недоступные действия.
enum AuthPermission {
  sportsWrite('SPORTS_WRITE'),
  statisticsReadAll('STATISTICS_READ_ALL'),
  transfer('TRANSFER'),
  obsAdmin('OBS_ADMIN'),
  apiDocs('API_DOCS'),
  accountAdmin('ACCOUNT_ADMIN');

  const AuthPermission(this.wireName);

  final String wireName;

  static AuthPermission? fromWire(String value) {
    for (final permission in values) {
      if (permission.wireName == value) return permission;
    }
    return null;
  }
}
