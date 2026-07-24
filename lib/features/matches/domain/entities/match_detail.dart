import 'package:ultistats/features/matches/domain/entities/team_match_result.dart';

enum MatchStatus {
  planned,
  inProgress,
  finished,
}

class MatchDetail {
  final String id;
  final List<TeamMatchResult> teams;
  final int eventCount;
  final String? diskHolderId;
  final DateTime? plannedStartTimestamp;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final MatchStatus status;

  const MatchDetail({
    required this.id,
    required this.teams,
    required this.eventCount,
    required this.status,
    this.diskHolderId,
    this.plannedStartTimestamp,
    this.startedAt,
    this.endedAt,
  });
}
