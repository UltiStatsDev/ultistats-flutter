import 'package:ultistats/features/teams/domain/entities/team.dart';

class Match {
  final String id;
  final List<Team> teams;
  final int eventCount;
  final String? diskHolderId;

  const Match({
    required this.id,
    required this.teams,
    required this.eventCount,
    this.diskHolderId,
  });
}
