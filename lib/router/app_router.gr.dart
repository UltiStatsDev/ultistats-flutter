// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;
import 'package:ultistats/features/dashboard/presentation/screens/dashboard_screen.dart'
    as _i1;
import 'package:ultistats/features/matches/presentation/screens/matches_list_screen.dart'
    as _i4;
import 'package:ultistats/features/players/presentation/screens/edit_player_screen.dart'
    as _i2;
import 'package:ultistats/features/players/presentation/screens/player_detail_screen.dart'
    as _i5;
import 'package:ultistats/features/players/presentation/screens/players_list_screen.dart'
    as _i6;
import 'package:ultistats/features/players/presentation/screens/players_tab_screen.dart'
    as _i7;
import 'package:ultistats/features/teams/presentation/screens/edit_team_screen.dart'
    as _i3;
import 'package:ultistats/features/teams/presentation/screens/teams_list_screen.dart'
    as _i8;
import 'package:ultistats/features/teams/presentation/screens/teams_tab_screen.dart'
    as _i9;

/// generated route for
/// [_i1.DashboardScreen]
class DashboardRoute extends _i10.PageRouteInfo<void> {
  const DashboardRoute({List<_i10.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i1.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i2.EditPlayerScreen]
class EditPlayerRoute extends _i10.PageRouteInfo<EditPlayerRouteArgs> {
  EditPlayerRoute({
    _i11.Key? key,
    required String title,
    required String confirmButtonText,
    _i2.EditPlayerScreenInitial initialData =
        const _i2.EditPlayerScreenInitial(),
    List<_i10.PageRouteInfo>? children,
  }) : super(
         EditPlayerRoute.name,
         args: EditPlayerRouteArgs(
           key: key,
           title: title,
           confirmButtonText: confirmButtonText,
           initialData: initialData,
         ),
         initialChildren: children,
       );

  static const String name = 'EditPlayerRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditPlayerRouteArgs>();
      return _i2.EditPlayerScreen(
        key: args.key,
        title: args.title,
        confirmButtonText: args.confirmButtonText,
        initialData: args.initialData,
      );
    },
  );
}

class EditPlayerRouteArgs {
  const EditPlayerRouteArgs({
    this.key,
    required this.title,
    required this.confirmButtonText,
    this.initialData = const _i2.EditPlayerScreenInitial(),
  });

  final _i11.Key? key;

  final String title;

  final String confirmButtonText;

  final _i2.EditPlayerScreenInitial initialData;

  @override
  String toString() {
    return 'EditPlayerRouteArgs{key: $key, title: $title, confirmButtonText: $confirmButtonText, initialData: $initialData}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditPlayerRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        confirmButtonText == other.confirmButtonText &&
        initialData == other.initialData;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      title.hashCode ^
      confirmButtonText.hashCode ^
      initialData.hashCode;
}

/// generated route for
/// [_i3.EditTeamScreen]
class EditTeamRoute extends _i10.PageRouteInfo<EditTeamRouteArgs> {
  EditTeamRoute({
    _i11.Key? key,
    required String title,
    required String confirmButtonText,
    _i3.EditTeamScreenInitial initialData = const _i3.EditTeamScreenInitial(),
    List<_i10.PageRouteInfo>? children,
  }) : super(
         EditTeamRoute.name,
         args: EditTeamRouteArgs(
           key: key,
           title: title,
           confirmButtonText: confirmButtonText,
           initialData: initialData,
         ),
         initialChildren: children,
       );

  static const String name = 'EditTeamRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditTeamRouteArgs>();
      return _i3.EditTeamScreen(
        key: args.key,
        title: args.title,
        confirmButtonText: args.confirmButtonText,
        initialData: args.initialData,
      );
    },
  );
}

class EditTeamRouteArgs {
  const EditTeamRouteArgs({
    this.key,
    required this.title,
    required this.confirmButtonText,
    this.initialData = const _i3.EditTeamScreenInitial(),
  });

  final _i11.Key? key;

  final String title;

  final String confirmButtonText;

  final _i3.EditTeamScreenInitial initialData;

  @override
  String toString() {
    return 'EditTeamRouteArgs{key: $key, title: $title, confirmButtonText: $confirmButtonText, initialData: $initialData}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditTeamRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        confirmButtonText == other.confirmButtonText &&
        initialData == other.initialData;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      title.hashCode ^
      confirmButtonText.hashCode ^
      initialData.hashCode;
}

/// generated route for
/// [_i4.MatchesListScreen]
class MatchesListRoute extends _i10.PageRouteInfo<void> {
  const MatchesListRoute({List<_i10.PageRouteInfo>? children})
    : super(MatchesListRoute.name, initialChildren: children);

  static const String name = 'MatchesListRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i4.MatchesListScreen();
    },
  );
}

/// generated route for
/// [_i5.PlayerDetailScreen]
class PlayerDetailRoute extends _i10.PageRouteInfo<PlayerDetailRouteArgs> {
  PlayerDetailRoute({
    _i11.Key? key,
    required String playerId,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         PlayerDetailRoute.name,
         args: PlayerDetailRouteArgs(key: key, playerId: playerId),
         initialChildren: children,
       );

  static const String name = 'PlayerDetailRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlayerDetailRouteArgs>();
      return _i5.PlayerDetailScreen(key: args.key, playerId: args.playerId);
    },
  );
}

class PlayerDetailRouteArgs {
  const PlayerDetailRouteArgs({this.key, required this.playerId});

  final _i11.Key? key;

  final String playerId;

  @override
  String toString() {
    return 'PlayerDetailRouteArgs{key: $key, playerId: $playerId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlayerDetailRouteArgs) return false;
    return key == other.key && playerId == other.playerId;
  }

  @override
  int get hashCode => key.hashCode ^ playerId.hashCode;
}

/// generated route for
/// [_i6.PlayersListScreen]
class PlayersListRoute extends _i10.PageRouteInfo<void> {
  const PlayersListRoute({List<_i10.PageRouteInfo>? children})
    : super(PlayersListRoute.name, initialChildren: children);

  static const String name = 'PlayersListRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i6.PlayersListScreen();
    },
  );
}

/// generated route for
/// [_i7.PlayersTabScreen]
class PlayersTabRoute extends _i10.PageRouteInfo<void> {
  const PlayersTabRoute({List<_i10.PageRouteInfo>? children})
    : super(PlayersTabRoute.name, initialChildren: children);

  static const String name = 'PlayersTabRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i7.PlayersTabScreen();
    },
  );
}

/// generated route for
/// [_i8.TeamsListScreen]
class TeamsListRoute extends _i10.PageRouteInfo<void> {
  const TeamsListRoute({List<_i10.PageRouteInfo>? children})
    : super(TeamsListRoute.name, initialChildren: children);

  static const String name = 'TeamsListRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i8.TeamsListScreen();
    },
  );
}

/// generated route for
/// [_i9.TeamsTabScreen]
class TeamsTabRoute extends _i10.PageRouteInfo<void> {
  const TeamsTabRoute({List<_i10.PageRouteInfo>? children})
    : super(TeamsTabRoute.name, initialChildren: children);

  static const String name = 'TeamsTabRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i9.TeamsTabScreen();
    },
  );
}
