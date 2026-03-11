import 'package:ultistats/features/matches/domain/entities/match_event.dart';

class CreateEventParams {
  final String matchId;
  final MatchEventType type;
  final DateTime timestamp;
  final String? teamId;
  final String? playerId;
  final String? toTeamId;
  final String? toPlayerId;

  const CreateEventParams({
    required this.matchId,
    required this.type,
    required this.timestamp,
    this.teamId,
    this.playerId,
    this.toTeamId,
    this.toPlayerId,
  });
}
