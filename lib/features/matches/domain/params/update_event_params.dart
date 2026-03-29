import 'package:ultistats/features/matches/domain/entities/match_event.dart';

class UpdateEventParams {
  final String matchId;
  final int index;
  final MatchEventType? type;
  final DateTime? timestamp;
  final String? teamId;
  final String? playerId;
  final String? toTeamId;
  final String? toPlayerId;

  const UpdateEventParams({
    required this.matchId,
    required this.index,
    this.type,
    this.timestamp,
    this.teamId,
    this.playerId,
    this.toTeamId,
    this.toPlayerId,
  });
}
