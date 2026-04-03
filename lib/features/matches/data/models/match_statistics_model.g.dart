// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchStatisticsModel _$MatchStatisticsModelFromJson(
  Map<String, dynamic> json,
) => MatchStatisticsModel(
  playerStatistics: (json['playerStatistics'] as List<dynamic>)
      .map((e) => PlayerStatisticsModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  teamStatistics: (json['teamStatistics'] as List<dynamic>)
      .map((e) => TeamStatisticsModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  timeStatistics: TimeStatisticsModel.fromJson(
    json['timeStatistics'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$MatchStatisticsModelToJson(
  MatchStatisticsModel instance,
) => <String, dynamic>{
  'playerStatistics': instance.playerStatistics.map((e) => e.toJson()).toList(),
  'teamStatistics': instance.teamStatistics.map((e) => e.toJson()).toList(),
  'timeStatistics': instance.timeStatistics.toJson(),
};

TimeStatisticsModel _$TimeStatisticsModelFromJson(Map<String, dynamic> json) =>
    TimeStatisticsModel(
      totalTime: json['totalTime'] as String,
      timeSpentBetweenPoints: json['timeSpentBetweenPoints'] as String,
      timeSpentOnTimeouts: json['timeSpentOnTimeouts'] as String,
      timeSpentOnHalftime: json['timeSpentOnHalftime'] as String,
      timeSpentOnViolationDiscussions:
          json['timeSpentOnViolationDiscussions'] as String,
      pureGameTime: json['pureGameTime'] as String,
    );

Map<String, dynamic> _$TimeStatisticsModelToJson(
  TimeStatisticsModel instance,
) => <String, dynamic>{
  'totalTime': instance.totalTime,
  'timeSpentBetweenPoints': instance.timeSpentBetweenPoints,
  'timeSpentOnTimeouts': instance.timeSpentOnTimeouts,
  'timeSpentOnHalftime': instance.timeSpentOnHalftime,
  'timeSpentOnViolationDiscussions': instance.timeSpentOnViolationDiscussions,
  'pureGameTime': instance.pureGameTime,
};
