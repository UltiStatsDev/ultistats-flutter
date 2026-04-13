// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:ultistats/features/dashboard/presentation/screens/dashboard_screen.dart'
    as _i2;
import 'package:ultistats/features/matches/presentation/screens/matches_list_screen.dart'
    as _i3;
import 'package:ultistats/features/players/presentation/screens/create_player_screen.dart'
    as _i1;
import 'package:ultistats/features/players/presentation/screens/players_list_screen.dart'
    as _i4;
import 'package:ultistats/features/players/presentation/screens/players_tab_screen.dart'
    as _i5;
import 'package:ultistats/features/teams/presentation/screens/teams_list_screen.dart'
    as _i6;

/// generated route for
/// [_i1.CreatePlayerScreen]
class CreatePlayerRoute extends _i7.PageRouteInfo<void> {
  const CreatePlayerRoute({List<_i7.PageRouteInfo>? children})
    : super(CreatePlayerRoute.name, initialChildren: children);

  static const String name = 'CreatePlayerRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.CreatePlayerScreen();
    },
  );
}

/// generated route for
/// [_i2.DashboardScreen]
class DashboardRoute extends _i7.PageRouteInfo<void> {
  const DashboardRoute({List<_i7.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i3.MatchesListScreen]
class MatchesListRoute extends _i7.PageRouteInfo<void> {
  const MatchesListRoute({List<_i7.PageRouteInfo>? children})
    : super(MatchesListRoute.name, initialChildren: children);

  static const String name = 'MatchesListRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.MatchesListScreen();
    },
  );
}

/// generated route for
/// [_i4.PlayersListScreen]
class PlayersListRoute extends _i7.PageRouteInfo<void> {
  const PlayersListRoute({List<_i7.PageRouteInfo>? children})
    : super(PlayersListRoute.name, initialChildren: children);

  static const String name = 'PlayersListRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.PlayersListScreen();
    },
  );
}

/// generated route for
/// [_i5.PlayersTabScreen]
class PlayersTabRoute extends _i7.PageRouteInfo<void> {
  const PlayersTabRoute({List<_i7.PageRouteInfo>? children})
    : super(PlayersTabRoute.name, initialChildren: children);

  static const String name = 'PlayersTabRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.PlayersTabScreen();
    },
  );
}

/// generated route for
/// [_i6.TeamsListScreen]
class TeamsListRoute extends _i7.PageRouteInfo<void> {
  const TeamsListRoute({List<_i7.PageRouteInfo>? children})
    : super(TeamsListRoute.name, initialChildren: children);

  static const String name = 'TeamsListRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.TeamsListScreen();
    },
  );
}
