import 'package:ultistats/features/matches/domain/entities/match_detail.dart';

class MatchListItem {
  final String id;
  final List<MatchListTeam> teams;
  final DateTime? plannedStartTimestamp;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final MatchStatus status;

  const MatchListItem({
    required this.id,
    required this.teams,
    required this.status,
    this.plannedStartTimestamp,
    this.startedAt,
    this.endedAt,
  });

  factory MatchListItem.placeholder() =>
      const MatchListItem(id: '0', teams: [], status: MatchStatus.planned);
}

class MatchListTeam {
  final String teamId;
  final String teamName;
  final int teamScore;
  final String? city;
  final String? photoUrl;

  const MatchListTeam({
    required this.teamId,
    required this.teamName,
    required this.teamScore,
    this.city,
    this.photoUrl,
  });
}
