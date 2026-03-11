import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/match_statistics.dart';

part 'match_statistics_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MatchStatisticsModel {
  final List<PlayerStatisticsModel> playerStatistics;
  final List<TeamStatisticsModel> teamStatistics;
  final TimeStatisticsModel timeStatistics;

  const MatchStatisticsModel({
    required this.playerStatistics,
    required this.teamStatistics,
    required this.timeStatistics,
  });

  factory MatchStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$MatchStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchStatisticsModelToJson(this);

  MatchStatistics toEntity() {
    return MatchStatistics(
      playerStatistics: playerStatistics.map((e) => e.toEntity()).toList(),
      teamStatistics: teamStatistics.map((e) => e.toEntity()).toList(),
      timeStatistics: timeStatistics.toEntity(),
    );
  }
}

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

@JsonSerializable(explicitToJson: true)
class TeamStatisticsModel {
  final String teamId;
  final TeamAttackStatsModel attack;
  final TeamDefenseStatsModel defense;
  final TeamTimeStatsModel time;

  const TeamStatisticsModel({
    required this.teamId,
    required this.attack,
    required this.defense,
    required this.time,
  });

  factory TeamStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$TeamStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamStatisticsModelToJson(this);

  TeamStatistics toEntity() => TeamStatistics(
        teamId: teamId,
        attack: attack.toEntity(),
        defense: defense.toEntity(),
        time: time.toEntity(),
      );
}

@JsonSerializable()
class TeamAttackStatsModel {
  final int score;
  final int breaks;
  final int completePasses;
  final int allPasses;
  final int pulls;
  final int bricks;
  final int possessions;
  final double possessionTime;
  final double percentOfPossession;

  const TeamAttackStatsModel({
    required this.score,
    required this.breaks,
    required this.completePasses,
    required this.allPasses,
    required this.pulls,
    required this.bricks,
    required this.possessions,
    required this.possessionTime,
    required this.percentOfPossession,
  });

  factory TeamAttackStatsModel.fromJson(Map<String, dynamic> json) =>
      _$TeamAttackStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamAttackStatsModelToJson(this);

  TeamAttackStats toEntity() => TeamAttackStats(
        score: score,
        breaks: breaks,
        completePasses: completePasses,
        allPasses: allPasses,
        pulls: pulls,
        bricks: bricks,
        possessions: possessions,
        possessionTime: possessionTime,
        percentOfPossession: percentOfPossession,
      );
}

@JsonSerializable()
class TeamDefenseStatsModel {
  final int blocksAsMarker;
  final int blocksAsFieldPlayer;
  final int interceptions;
  final int callahans;

  const TeamDefenseStatsModel({
    required this.blocksAsMarker,
    required this.blocksAsFieldPlayer,
    required this.interceptions,
    required this.callahans,
  });

  factory TeamDefenseStatsModel.fromJson(Map<String, dynamic> json) =>
      _$TeamDefenseStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamDefenseStatsModelToJson(this);

  TeamDefenseStats toEntity() => TeamDefenseStats(
        blocksAsMarker: blocksAsMarker,
        blocksAsFieldPlayer: blocksAsFieldPlayer,
        interceptions: interceptions,
        callahans: callahans,
      );
}

@JsonSerializable()
class TeamTimeStatsModel {
  final String totalPossessionTime;
  final String totalTimeBetweenPoints;
  final String totalTimeSpentOnTimeouts;

  const TeamTimeStatsModel({
    required this.totalPossessionTime,
    required this.totalTimeBetweenPoints,
    required this.totalTimeSpentOnTimeouts,
  });

  factory TeamTimeStatsModel.fromJson(Map<String, dynamic> json) =>
      _$TeamTimeStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamTimeStatsModelToJson(this);

  TeamTimeStats toEntity() => TeamTimeStats(
        totalPossessionTime: totalPossessionTime,
        totalTimeBetweenPoints: totalTimeBetweenPoints,
        totalTimeSpentOnTimeouts: totalTimeSpentOnTimeouts,
      );
}

@JsonSerializable()
class TimeStatisticsModel {
  final String totalTime;
  final String timeSpentBetweenPoints;
  final String timeSpentOnTimeouts;
  final String timeSpentOnHalftime;
  final String timeSpentOnViolationDiscussions;
  final String pureGameTime;

  const TimeStatisticsModel({
    required this.totalTime,
    required this.timeSpentBetweenPoints,
    required this.timeSpentOnTimeouts,
    required this.timeSpentOnHalftime,
    required this.timeSpentOnViolationDiscussions,
    required this.pureGameTime,
  });

  factory TimeStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$TimeStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimeStatisticsModelToJson(this);

  TimeStatistics toEntity() => TimeStatistics(
        totalTime: totalTime,
        timeSpentBetweenPoints: timeSpentBetweenPoints,
        timeSpentOnTimeouts: timeSpentOnTimeouts,
        timeSpentOnHalftime: timeSpentOnHalftime,
        timeSpentOnViolationDiscussions: timeSpentOnViolationDiscussions,
        pureGameTime: pureGameTime,
      );
}
