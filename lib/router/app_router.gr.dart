// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:ultistats/features/dashboard/presentation/screens/dashboard_screen.dart'
    as _i1;
import 'package:ultistats/features/matches/presentation/screens/matches_list_screen.dart'
    as _i2;
import 'package:ultistats/features/players/presentation/screens/players_list_screen.dart'
    as _i3;
import 'package:ultistats/features/teams/presentation/screens/teams_list_screen.dart'
    as _i4;

/// generated route for
/// [_i1.DashboardScreen]
class DashboardRoute extends _i5.PageRouteInfo<void> {
  const DashboardRoute({List<_i5.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i2.MatchesListScreen]
class MatchesListRoute extends _i5.PageRouteInfo<void> {
  const MatchesListRoute({List<_i5.PageRouteInfo>? children})
    : super(MatchesListRoute.name, initialChildren: children);

  static const String name = 'MatchesListRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.MatchesListScreen();
    },
  );
}

/// generated route for
/// [_i3.PlayersListScreen]
class PlayersListRoute extends _i5.PageRouteInfo<void> {
  const PlayersListRoute({List<_i5.PageRouteInfo>? children})
    : super(PlayersListRoute.name, initialChildren: children);

  static const String name = 'PlayersListRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.PlayersListScreen();
    },
  );
}

/// generated route for
/// [_i4.TeamsListScreen]
class TeamsListRoute extends _i5.PageRouteInfo<void> {
  const TeamsListRoute({List<_i5.PageRouteInfo>? children})
    : super(TeamsListRoute.name, initialChildren: children);

  static const String name = 'TeamsListRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.TeamsListScreen();
    },
  );
}
