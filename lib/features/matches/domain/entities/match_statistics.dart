class MatchStatistics {
  final List<PlayerStatistics> playerStatistics;
  final List<TeamStatistics> teamStatistics;
  final TimeStatistics timeStatistics;

  const MatchStatistics({
    required this.playerStatistics,
    required this.teamStatistics,
    required this.timeStatistics,
  });
}

class PlayerStatistics {
  final String playerId;
  final PlayerAttackStats attack;
  final PlayerDefenseStats defense;
  final PlayerTimeStats time;

  const PlayerStatistics({
    required this.playerId,
    required this.attack,
    required this.defense,
    required this.time,
  });
}

class PlayerAttackStats {
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

  const PlayerAttackStats({
    this.passes = 0,
    this.catches = 0,
    this.assists = 0,
    this.goals = 0,
    this.saves = 0,
    this.saveGoals = 0,
    this.dropsOnMarker = 0,
    this.dropsOnField = 0,
    this.drops = 0,
    this.callahanDrops = 0,
    this.discPossessions = 0,
    this.pulls = 0,
    this.bricks = 0,
  });
}

class PlayerDefenseStats {
  final int blocksAsMarker;
  final int blocksAsFieldPlayer;
  final int interceptions;
  final int callahans;

  const PlayerDefenseStats({
    this.blocksAsMarker = 0,
    this.blocksAsFieldPlayer = 0,
    this.interceptions = 0,
    this.callahans = 0,
  });
}

class PlayerTimeStats {
  final String totalPossessionTime;
  final String averagePossessionTime;

  const PlayerTimeStats({
    required this.totalPossessionTime,
    required this.averagePossessionTime,
  });
}

class TeamStatistics {
  final String teamId;
  final TeamAttackStats attack;
  final TeamDefenseStats defense;
  final TeamTimeStats time;

  const TeamStatistics({
    required this.teamId,
    required this.attack,
    required this.defense,
    required this.time,
  });
}

class TeamAttackStats {
  final int score;
  final int breaks;
  final int completePasses;
  final int allPasses;
  final int pulls;
  final int bricks;
  final int possessions;
  final double possessionTime;
  final double percentOfPossession;

  const TeamAttackStats({
    this.score = 0,
    this.breaks = 0,
    this.completePasses = 0,
    this.allPasses = 0,
    this.pulls = 0,
    this.bricks = 0,
    this.possessions = 0,
    this.possessionTime = 0.0,
    this.percentOfPossession = 0.0,
  });
}

class TeamDefenseStats {
  final int blocksAsMarker;
  final int blocksAsFieldPlayer;
  final int interceptions;
  final int callahans;

  const TeamDefenseStats({
    this.blocksAsMarker = 0,
    this.blocksAsFieldPlayer = 0,
    this.interceptions = 0,
    this.callahans = 0,
  });
}

class TeamTimeStats {
  final String totalPossessionTime;
  final String totalTimeBetweenPoints;
  final String totalTimeSpentOnTimeouts;

  const TeamTimeStats({
    required this.totalPossessionTime,
    required this.totalTimeBetweenPoints,
    required this.totalTimeSpentOnTimeouts,
  });
}

class TimeStatistics {
  final String totalTime;
  final String timeSpentBetweenPoints;
  final String timeSpentOnTimeouts;
  final String timeSpentOnHalftime;
  final String timeSpentOnViolationDiscussions;
  final String pureGameTime;

  const TimeStatistics({
    required this.totalTime,
    required this.timeSpentBetweenPoints,
    required this.timeSpentOnTimeouts,
    required this.timeSpentOnHalftime,
    required this.timeSpentOnViolationDiscussions,
    required this.pureGameTime,
  });
}
