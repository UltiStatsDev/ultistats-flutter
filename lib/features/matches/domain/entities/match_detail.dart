import 'package:ultistats/features/matches/domain/entities/match_team.dart';

enum MatchStatus {
  planned,
  inProgress,
  finished;

  static MatchStatus parse(String status) {
    return switch (status.toUpperCase()) {
      'PLANNED' => MatchStatus.planned,
      'IN_PROGRESS' => MatchStatus.inProgress,
      'FINISHED' => MatchStatus.finished,
      _ => MatchStatus.planned,
    };
  }
}

class MatchDetail {
  final String id;
  final List<MatchTeam> teams;
  final int eventCount;
  final DateTime? plannedStartTimestamp;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final MatchStatus status;

  const MatchDetail({
    required this.id,
    required this.teams,
    required this.eventCount,
    required this.status,
    this.plannedStartTimestamp,
    this.startedAt,
    this.endedAt,
  });
}
