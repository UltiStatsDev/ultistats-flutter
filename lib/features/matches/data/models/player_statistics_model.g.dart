// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
