import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/match_event.dart';
import 'package:ultistats/features/matches/domain/params/create_event_params.dart';

part 'create_event_request.g.dart';

@JsonSerializable(includeIfNull: false)
class CreateEventRequest {
  final MatchEventType type;
  final String timestamp;
  final String? teamId;
  final String? playerId;
  final String? toTeamId;
  final String? toPlayerId;

  const CreateEventRequest({
    required this.type,
    required this.timestamp,
    this.teamId,
    this.playerId,
    this.toTeamId,
    this.toPlayerId,
  });

  factory CreateEventRequest.fromParams(CreateEventParams params) =>
      CreateEventRequest(
        type: params.type,
        timestamp: params.timestamp.toUtc().toIso8601String(),
        teamId: params.teamId,
        playerId: params.playerId,
        toTeamId: params.toTeamId,
        toPlayerId: params.toPlayerId,
      );

  Map<String, dynamic> toJson() => _$CreateEventRequestToJson(this);
}
