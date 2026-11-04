/// Способ попросить фичу `matches` обновить свои данные.
///
/// Живёт в domain, чтобы другие фичи (например `match_game`) не зависели
/// от конкретных Riverpod-провайдеров презентационного слоя `matches`.
abstract interface class MatchesRefresh {
  void refreshDetail();

  void refreshList();
}
