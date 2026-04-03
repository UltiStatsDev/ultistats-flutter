import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/data/models/player_statistics_model.dart';
import 'package:ultistats/features/matches/data/models/team_statistics_model.dart';
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
