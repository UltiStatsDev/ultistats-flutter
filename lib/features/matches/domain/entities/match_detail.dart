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
  final int playersPerTeam;
  final DateTime? plannedStartTimestamp;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final MatchStatus status;

  const MatchDetail({
    required this.id,
    required this.teams,
    required this.eventCount,
    required this.playersPerTeam,
    required this.status,
    this.plannedStartTimestamp,
    this.startedAt,
    this.endedAt,
  });

  MatchDetail copyWith({
    List<MatchTeam>? teams,
    MatchStatus? status,
    DateTime? endedAt,
    int? eventCount,
    int? playersPerTeam,
  }) {
    return MatchDetail(
      id: id,
      teams: teams ?? this.teams,
      eventCount: eventCount ?? this.eventCount,
      playersPerTeam: playersPerTeam ?? this.playersPerTeam,
      status: status ?? this.status,
      plannedStartTimestamp: plannedStartTimestamp,
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchDetail &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
