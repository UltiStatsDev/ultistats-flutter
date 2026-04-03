import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/match_statistics.dart';

part 'player_statistics_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerStatisticsModel {
  final String playerId;
  final PlayerAttackStatsModel attack;
  final PlayerDefenseStatsModel defense;
  final PlayerTimeStatsModel time;

  const PlayerStatisticsModel({
    required this.playerId,
    required this.attack,
    required this.defense,
    required this.time,
  });

  factory PlayerStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerStatisticsModelToJson(this);

  PlayerStatistics toEntity() {
    return PlayerStatistics(
      playerId: playerId,
      attack: attack.toEntity(),
      defense: defense.toEntity(),
      time: time.toEntity(),
    );
  }
}

@JsonSerializable()
class PlayerAttackStatsModel {
  final int passes;
  final int catches;
  final int assists;
  final int goals;
  final int saves;
  final int saveGoals;
  final int dropsOnMarker;
  final int dropsOnField;
  final int drops;
  final int callahanDrops;
  final int discPossessions;
  final int pulls;
  final int bricks;

  const PlayerAttackStatsModel({
    required this.passes,
    required this.catches,
    required this.assists,
    required this.goals,
    required this.saves,
    required this.saveGoals,
    required this.dropsOnMarker,
    required this.dropsOnField,
    required this.drops,
    required this.callahanDrops,
    required this.discPossessions,
    required this.pulls,
    required this.bricks,
  });

  factory PlayerAttackStatsModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerAttackStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerAttackStatsModelToJson(this);

  PlayerAttackStats toEntity() => PlayerAttackStats(
        passes: passes,
        catches: catches,
        assists: assists,
        goals: goals,
        saves: saves,
        saveGoals: saveGoals,
        dropsOnMarker: dropsOnMarker,
        dropsOnField: dropsOnField,
        drops: drops,
        callahanDrops: callahanDrops,
        discPossessions: discPossessions,
        pulls: pulls,
        bricks: bricks,
      );
}

@JsonSerializable()
class PlayerDefenseStatsModel {
  final int blocksAsMarker;
  final int blocksAsFieldPlayer;
  final int interceptions;
  final int callahans;

  const PlayerDefenseStatsModel({
    required this.blocksAsMarker,
    required this.blocksAsFieldPlayer,
    required this.interceptions,
    required this.callahans,
  });

  factory PlayerDefenseStatsModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerDefenseStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerDefenseStatsModelToJson(this);

  PlayerDefenseStats toEntity() => PlayerDefenseStats(
        blocksAsMarker: blocksAsMarker,
        blocksAsFieldPlayer: blocksAsFieldPlayer,
        interceptions: interceptions,
        callahans: callahans,
      );
}

@JsonSerializable()
class PlayerTimeStatsModel {
  final String totalPossessionTime;
  final String averagePossessionTime;

  const PlayerTimeStatsModel({
    required this.totalPossessionTime,
    required this.averagePossessionTime,
  });

  factory PlayerTimeStatsModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerTimeStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerTimeStatsModelToJson(this);

  PlayerTimeStats toEntity() => PlayerTimeStats(
        totalPossessionTime: totalPossessionTime,
        averagePossessionTime: averagePossessionTime,
      );
}
