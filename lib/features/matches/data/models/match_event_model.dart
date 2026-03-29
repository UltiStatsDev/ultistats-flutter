import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/match_event.dart';

part 'match_event_model.g.dart';

@JsonSerializable()
class MatchEventModel {
  final MatchEventType type;
  @JsonKey(name: "realTimestamp")
  final DateTime timestamp;
  final String? team;
  final String? player;
  final String? fromTeam;
  final String? fromPlayer;
  final String? toTeam;
  final String? toPlayer;

  const MatchEventModel({
    required this.type,
    required this.timestamp,
    this.team,
    this.player,
    this.fromTeam,
    this.fromPlayer,
    this.toTeam,
    this.toPlayer,
  });

  factory MatchEventModel.fromJson(Map<String, dynamic> json) =>
      _$MatchEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchEventModelToJson(this);

  MatchEvent toEntity() {
    return MatchEvent(
      type: type,
      timestamp: timestamp,
      teamId: team ?? fromTeam,
      playerId: player ?? fromPlayer,
      toTeamId: toTeam,
      toPlayerId: toPlayer,
    );
  }
}
