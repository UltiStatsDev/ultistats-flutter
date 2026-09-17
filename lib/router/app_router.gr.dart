// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i16;
import 'package:flutter/material.dart' as _i17;
import 'package:ultistats/features/dashboard/presentation/screens/dashboard_screen.dart'
    as _i1;
import 'package:ultistats/features/matches/presentation/screens/edit_match_screen.dart'
    as _i2;
import 'package:ultistats/features/matches/presentation/screens/match_detail_screen.dart'
    as _i5;
import 'package:ultistats/features/matches/presentation/screens/match_preparation_screen.dart'
    as _i6;
import 'package:ultistats/features/matches/presentation/screens/match_screen.dart'
    as _i7;
import 'package:ultistats/features/matches/presentation/screens/matches_list_screen.dart'
    as _i8;
import 'package:ultistats/features/matches/presentation/screens/matches_tab_screen.dart'
    as _i9;
import 'package:ultistats/features/players/presentation/screens/edit_player_screen.dart'
    as _i3;
import 'package:ultistats/features/players/presentation/screens/player_detail_screen.dart'
    as _i10;
import 'package:ultistats/features/players/presentation/screens/players_list_screen.dart'
    as _i11;
import 'package:ultistats/features/players/presentation/screens/players_tab_screen.dart'
    as _i12;
import 'package:ultistats/features/teams/presentation/screens/edit_team_screen.dart'
    as _i4;
import 'package:ultistats/features/teams/presentation/screens/team_detail_screen.dart'
    as _i13;
import 'package:ultistats/features/teams/presentation/screens/teams_list_screen.dart'
    as _i14;
import 'package:ultistats/features/teams/presentation/screens/teams_tab_screen.dart'
    as _i15;

/// generated route for
/// [_i1.DashboardScreen]
class DashboardRoute extends _i16.PageRouteInfo<void> {
  const DashboardRoute({List<_i16.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i1.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i2.EditMatchScreen]
class EditMatchRoute extends _i16.PageRouteInfo<EditMatchRouteArgs> {
  EditMatchRoute({
    _i17.Key? key,
    required String title,
    required String confirmButtonText,
    _i2.EditMatchScreenInitial initialData = const _i2.EditMatchScreenInitial(),
    List<_i16.PageRouteInfo>? children,
  }) : super(
         EditMatchRoute.name,
         args: EditMatchRouteArgs(
           key: key,
           title: title,
           confirmButtonText: confirmButtonText,
           initialData: initialData,
         ),
         initialChildren: children,
       );

  static const String name = 'EditMatchRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditMatchRouteArgs>();
      return _i2.EditMatchScreen(
        key: args.key,
        title: args.title,
        confirmButtonText: args.confirmButtonText,
        initialData: args.initialData,
      );
    },
  );
}

class EditMatchRouteArgs {
  const EditMatchRouteArgs({
    this.key,
    required this.title,
    required this.confirmButtonText,
    this.initialData = const _i2.EditMatchScreenInitial(),
  });

  final _i17.Key? key;

  final String title;

  final String confirmButtonText;

  final _i2.EditMatchScreenInitial initialData;

  @override
  String toString() {
    return 'EditMatchRouteArgs{key: $key, title: $title, confirmButtonText: $confirmButtonText, initialData: $initialData}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditMatchRouteArgs) return false;
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
/// [_i3.EditPlayerScreen]
class EditPlayerRoute extends _i16.PageRouteInfo<EditPlayerRouteArgs> {
  EditPlayerRoute({
    _i17.Key? key,
    required String title,
    required String confirmButtonText,
    _i3.EditPlayerScreenInitial initialData =
        const _i3.EditPlayerScreenInitial(),
    List<_i16.PageRouteInfo>? children,
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

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditPlayerRouteArgs>();
      return _i3.EditPlayerScreen(
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
    this.initialData = const _i3.EditPlayerScreenInitial(),
  });

  final _i17.Key? key;

  final String title;

  final String confirmButtonText;

  final _i3.EditPlayerScreenInitial initialData;

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
/// [_i4.EditTeamScreen]
class EditTeamRoute extends _i16.PageRouteInfo<EditTeamRouteArgs> {
  EditTeamRoute({
    _i17.Key? key,
    required String title,
    required String confirmButtonText,
    _i4.EditTeamScreenInitial initialData = const _i4.EditTeamScreenInitial(),
    List<_i16.PageRouteInfo>? children,
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

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditTeamRouteArgs>();
      return _i4.EditTeamScreen(
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
    this.initialData = const _i4.EditTeamScreenInitial(),
  });

  final _i17.Key? key;

  final String title;

  final String confirmButtonText;

  final _i4.EditTeamScreenInitial initialData;

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
/// [_i5.MatchDetailScreen]
class MatchDetailRoute extends _i16.PageRouteInfo<MatchDetailRouteArgs> {
  MatchDetailRoute({
    _i17.Key? key,
    required String matchId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         MatchDetailRoute.name,
         args: MatchDetailRouteArgs(key: key, matchId: matchId),
         initialChildren: children,
       );

  static const String name = 'MatchDetailRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MatchDetailRouteArgs>();
      return _i5.MatchDetailScreen(key: args.key, matchId: args.matchId);
    },
  );
}

class MatchDetailRouteArgs {
  const MatchDetailRouteArgs({this.key, required this.matchId});

  final _i17.Key? key;

  final String matchId;

  @override
  String toString() {
    return 'MatchDetailRouteArgs{key: $key, matchId: $matchId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MatchDetailRouteArgs) return false;
    return key == other.key && matchId == other.matchId;
  }

  @override
  int get hashCode => key.hashCode ^ matchId.hashCode;
}

/// generated route for
/// [_i6.MatchPreparationScreen]
class MatchPreparationRoute
    extends _i16.PageRouteInfo<MatchPreparationRouteArgs> {
  MatchPreparationRoute({
    _i17.Key? key,
    required String matchId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         MatchPreparationRoute.name,
         args: MatchPreparationRouteArgs(key: key, matchId: matchId),
         initialChildren: children,
       );

  static const String name = 'MatchPreparationRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MatchPreparationRouteArgs>();
      return _i6.MatchPreparationScreen(key: args.key, matchId: args.matchId);
    },
  );
}

class MatchPreparationRouteArgs {
  const MatchPreparationRouteArgs({this.key, required this.matchId});

  final _i17.Key? key;

  final String matchId;

  @override
  String toString() {
    return 'MatchPreparationRouteArgs{key: $key, matchId: $matchId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MatchPreparationRouteArgs) return false;
    return key == other.key && matchId == other.matchId;
  }

  @override
  int get hashCode => key.hashCode ^ matchId.hashCode;
}

/// generated route for
/// [_i7.MatchScreen]
class MatchRoute extends _i16.PageRouteInfo<void> {
  const MatchRoute({List<_i16.PageRouteInfo>? children})
    : super(MatchRoute.name, initialChildren: children);

  static const String name = 'MatchRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i7.MatchScreen();
    },
  );
}

/// generated route for
/// [_i8.MatchesListScreen]
class MatchesListRoute extends _i16.PageRouteInfo<void> {
  const MatchesListRoute({List<_i16.PageRouteInfo>? children})
    : super(MatchesListRoute.name, initialChildren: children);

  static const String name = 'MatchesListRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i8.MatchesListScreen();
    },
  );
}

/// generated route for
/// [_i9.MatchesTabScreen]
class MatchesTabRoute extends _i16.PageRouteInfo<void> {
  const MatchesTabRoute({List<_i16.PageRouteInfo>? children})
    : super(MatchesTabRoute.name, initialChildren: children);

  static const String name = 'MatchesTabRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i9.MatchesTabScreen();
    },
  );
}

/// generated route for
/// [_i10.PlayerDetailScreen]
class PlayerDetailRoute extends _i16.PageRouteInfo<PlayerDetailRouteArgs> {
  PlayerDetailRoute({
    _i17.Key? key,
    required String playerId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         PlayerDetailRoute.name,
         args: PlayerDetailRouteArgs(key: key, playerId: playerId),
         initialChildren: children,
       );

  static const String name = 'PlayerDetailRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlayerDetailRouteArgs>();
      return _i10.PlayerDetailScreen(key: args.key, playerId: args.playerId);
    },
  );
}

class PlayerDetailRouteArgs {
  const PlayerDetailRouteArgs({this.key, required this.playerId});

  final _i17.Key? key;

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
/// [_i11.PlayersListScreen]
class PlayersListRoute extends _i16.PageRouteInfo<void> {
  const PlayersListRoute({List<_i16.PageRouteInfo>? children})
    : super(PlayersListRoute.name, initialChildren: children);

  static const String name = 'PlayersListRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i11.PlayersListScreen();
    },
  );
}

/// generated route for
/// [_i12.PlayersTabScreen]
class PlayersTabRoute extends _i16.PageRouteInfo<void> {
  const PlayersTabRoute({List<_i16.PageRouteInfo>? children})
    : super(PlayersTabRoute.name, initialChildren: children);

  static const String name = 'PlayersTabRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i12.PlayersTabScreen();
    },
  );
}

/// generated route for
/// [_i13.TeamDetailScreen]
class TeamDetailRoute extends _i16.PageRouteInfo<TeamDetailRouteArgs> {
  TeamDetailRoute({
    _i17.Key? key,
    required String teamId,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         TeamDetailRoute.name,
         args: TeamDetailRouteArgs(key: key, teamId: teamId),
         initialChildren: children,
       );

  static const String name = 'TeamDetailRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TeamDetailRouteArgs>();
      return _i13.TeamDetailScreen(key: args.key, teamId: args.teamId);
    },
  );
}

class TeamDetailRouteArgs {
  const TeamDetailRouteArgs({this.key, required this.teamId});

  final _i17.Key? key;

  final String teamId;

  @override
  String toString() {
    return 'TeamDetailRouteArgs{key: $key, teamId: $teamId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TeamDetailRouteArgs) return false;
    return key == other.key && teamId == other.teamId;
  }

  @override
  int get hashCode => key.hashCode ^ teamId.hashCode;
}

/// generated route for
/// [_i14.TeamsListScreen]
class TeamsListRoute extends _i16.PageRouteInfo<void> {
  const TeamsListRoute({List<_i16.PageRouteInfo>? children})
    : super(TeamsListRoute.name, initialChildren: children);

  static const String name = 'TeamsListRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i14.TeamsListScreen();
    },
  );
}

/// generated route for
/// [_i15.TeamsTabScreen]
class TeamsTabRoute extends _i16.PageRouteInfo<void> {
  const TeamsTabRoute({List<_i16.PageRouteInfo>? children})
    : super(TeamsTabRoute.name, initialChildren: children);

  static const String name = 'TeamsTabRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i15.TeamsTabScreen();
    },
  );
}
