import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/params/create_match_params.dart';

part 'create_match_request.g.dart';

@JsonSerializable(includeIfNull: false)
class CreateMatchRequest {
  final List<String> teamIds;
  final String? plannedStartTimestamp;
  final int playersPerTeam;

  const CreateMatchRequest({
    required this.teamIds,
    required this.playersPerTeam,
    this.plannedStartTimestamp,
  });

  factory CreateMatchRequest.fromParams(CreateMatchParams params) =>
      CreateMatchRequest(
        teamIds: params.teamIds,
        playersPerTeam: params.playersPerTeam,
        plannedStartTimestamp: params.plannedStartTimestamp
            ?.toUtc()
            .toIso8601String(),
      );

  Map<String, dynamic> toJson() => _$CreateMatchRequestToJson(this);
}
