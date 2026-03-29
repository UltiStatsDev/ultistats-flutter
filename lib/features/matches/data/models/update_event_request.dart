import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/match_event.dart';
import 'package:ultistats/features/matches/domain/params/update_event_params.dart';

part 'update_event_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateEventRequest {
  final MatchEventType? type;
  final String? timestamp;
  final String? teamId;
  final String? playerId;
  final String? toTeamId;
  final String? toPlayerId;

  const UpdateEventRequest({
    this.type,
    this.timestamp,
    this.teamId,
    this.playerId,
    this.toTeamId,
    this.toPlayerId,
  });

  factory UpdateEventRequest.fromParams(UpdateEventParams params) =>
      UpdateEventRequest(
        type: params.type,
        timestamp: params.timestamp?.toUtc().toIso8601String(),
        teamId: params.teamId,
        playerId: params.playerId,
        toTeamId: params.toTeamId,
        toPlayerId: params.toPlayerId,
      );

  Map<String, dynamic> toJson() => _$UpdateEventRequestToJson(this);
}
