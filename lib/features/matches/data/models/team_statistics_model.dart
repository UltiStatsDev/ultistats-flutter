import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/match_statistics.dart';

part 'team_statistics_model.g.dart';

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

  TeamStatistics toEntity() {
    return TeamStatistics(
      teamId: teamId,
      attack: attack.toEntity(),
      defense: defense.toEntity(),
      time: time.toEntity(),
    );
  }
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
