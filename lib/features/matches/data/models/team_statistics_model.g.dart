// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
