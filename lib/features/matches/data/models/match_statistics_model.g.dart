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

PlayerStatisticsModel _$PlayerStatisticsModelFromJson(
  Map<String, dynamic> json,
) => PlayerStatisticsModel(
  playerId: json['playerId'] as String,
  attack: PlayerAttackStatsModel.fromJson(
    json['attack'] as Map<String, dynamic>,
  ),
  defense: PlayerDefenseStatsModel.fromJson(
    json['defense'] as Map<String, dynamic>,
  ),
  time: PlayerTimeStatsModel.fromJson(json['time'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PlayerStatisticsModelToJson(
  PlayerStatisticsModel instance,
) => <String, dynamic>{
  'playerId': instance.playerId,
  'attack': instance.attack.toJson(),
  'defense': instance.defense.toJson(),
  'time': instance.time.toJson(),
};

PlayerAttackStatsModel _$PlayerAttackStatsModelFromJson(
  Map<String, dynamic> json,
) => PlayerAttackStatsModel(
  passes: (json['passes'] as num).toInt(),
  catches: (json['catches'] as num).toInt(),
  assists: (json['assists'] as num).toInt(),
  goals: (json['goals'] as num).toInt(),
  saves: (json['saves'] as num).toInt(),
  saveGoals: (json['saveGoals'] as num).toInt(),
  dropsOnMarker: (json['dropsOnMarker'] as num).toInt(),
  dropsOnField: (json['dropsOnField'] as num).toInt(),
  drops: (json['drops'] as num).toInt(),
  callahanDrops: (json['callahanDrops'] as num).toInt(),
  discPossessions: (json['discPossessions'] as num).toInt(),
  pulls: (json['pulls'] as num).toInt(),
  bricks: (json['bricks'] as num).toInt(),
);

Map<String, dynamic> _$PlayerAttackStatsModelToJson(
  PlayerAttackStatsModel instance,
) => <String, dynamic>{
  'passes': instance.passes,
  'catches': instance.catches,
  'assists': instance.assists,
  'goals': instance.goals,
  'saves': instance.saves,
  'saveGoals': instance.saveGoals,
  'dropsOnMarker': instance.dropsOnMarker,
  'dropsOnField': instance.dropsOnField,
  'drops': instance.drops,
  'callahanDrops': instance.callahanDrops,
  'discPossessions': instance.discPossessions,
  'pulls': instance.pulls,
  'bricks': instance.bricks,
};

PlayerDefenseStatsModel _$PlayerDefenseStatsModelFromJson(
  Map<String, dynamic> json,
) => PlayerDefenseStatsModel(
  blocksAsMarker: (json['blocksAsMarker'] as num).toInt(),
  blocksAsFieldPlayer: (json['blocksAsFieldPlayer'] as num).toInt(),
  interceptions: (json['interceptions'] as num).toInt(),
  callahans: (json['callahans'] as num).toInt(),
);

Map<String, dynamic> _$PlayerDefenseStatsModelToJson(
  PlayerDefenseStatsModel instance,
) => <String, dynamic>{
  'blocksAsMarker': instance.blocksAsMarker,
  'blocksAsFieldPlayer': instance.blocksAsFieldPlayer,
  'interceptions': instance.interceptions,
  'callahans': instance.callahans,
};

PlayerTimeStatsModel _$PlayerTimeStatsModelFromJson(
  Map<String, dynamic> json,
) => PlayerTimeStatsModel(
  totalPossessionTime: json['totalPossessionTime'] as String,
  averagePossessionTime: json['averagePossessionTime'] as String,
);

Map<String, dynamic> _$PlayerTimeStatsModelToJson(
  PlayerTimeStatsModel instance,
) => <String, dynamic>{
  'totalPossessionTime': instance.totalPossessionTime,
  'averagePossessionTime': instance.averagePossessionTime,
};

TeamStatisticsModel _$TeamStatisticsModelFromJson(Map<String, dynamic> json) =>
    TeamStatisticsModel(
      teamId: json['teamId'] as String,
      attack: TeamAttackStatsModel.fromJson(
        json['attack'] as Map<String, dynamic>,
      ),
      defense: TeamDefenseStatsModel.fromJson(
        json['defense'] as Map<String, dynamic>,
      ),
      time: TeamTimeStatsModel.fromJson(json['time'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeamStatisticsModelToJson(
  TeamStatisticsModel instance,
) => <String, dynamic>{
  'teamId': instance.teamId,
  'attack': instance.attack.toJson(),
  'defense': instance.defense.toJson(),
  'time': instance.time.toJson(),
};

TeamAttackStatsModel _$TeamAttackStatsModelFromJson(
  Map<String, dynamic> json,
) => TeamAttackStatsModel(
  score: (json['score'] as num).toInt(),
  breaks: (json['breaks'] as num).toInt(),
  completePasses: (json['completePasses'] as num).toInt(),
  allPasses: (json['allPasses'] as num).toInt(),
  pulls: (json['pulls'] as num).toInt(),
  bricks: (json['bricks'] as num).toInt(),
  possessions: (json['possessions'] as num).toInt(),
  possessionTime: (json['possessionTime'] as num).toDouble(),
  percentOfPossession: (json['percentOfPossession'] as num).toDouble(),
);

Map<String, dynamic> _$TeamAttackStatsModelToJson(
  TeamAttackStatsModel instance,
) => <String, dynamic>{
  'score': instance.score,
  'breaks': instance.breaks,
  'completePasses': instance.completePasses,
  'allPasses': instance.allPasses,
  'pulls': instance.pulls,
  'bricks': instance.bricks,
  'possessions': instance.possessions,
  'possessionTime': instance.possessionTime,
  'percentOfPossession': instance.percentOfPossession,
};

TeamDefenseStatsModel _$TeamDefenseStatsModelFromJson(
  Map<String, dynamic> json,
) => TeamDefenseStatsModel(
  blocksAsMarker: (json['blocksAsMarker'] as num).toInt(),
  blocksAsFieldPlayer: (json['blocksAsFieldPlayer'] as num).toInt(),
  interceptions: (json['interceptions'] as num).toInt(),
  callahans: (json['callahans'] as num).toInt(),
);

Map<String, dynamic> _$TeamDefenseStatsModelToJson(
  TeamDefenseStatsModel instance,
) => <String, dynamic>{
  'blocksAsMarker': instance.blocksAsMarker,
  'blocksAsFieldPlayer': instance.blocksAsFieldPlayer,
  'interceptions': instance.interceptions,
  'callahans': instance.callahans,
};

TeamTimeStatsModel _$TeamTimeStatsModelFromJson(Map<String, dynamic> json) =>
    TeamTimeStatsModel(
      totalPossessionTime: json['totalPossessionTime'] as String,
      totalTimeBetweenPoints: json['totalTimeBetweenPoints'] as String,
      totalTimeSpentOnTimeouts: json['totalTimeSpentOnTimeouts'] as String,
    );

Map<String, dynamic> _$TeamTimeStatsModelToJson(TeamTimeStatsModel instance) =>
    <String, dynamic>{
      'totalPossessionTime': instance.totalPossessionTime,
      'totalTimeBetweenPoints': instance.totalTimeBetweenPoints,
      'totalTimeSpentOnTimeouts': instance.totalTimeSpentOnTimeouts,
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
