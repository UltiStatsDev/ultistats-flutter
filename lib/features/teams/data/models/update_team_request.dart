import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/teams/domain/params/update_team_params.dart';

part 'update_team_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateTeamRequest {
  final String? name;
  final List<String>? playerIds;

  const UpdateTeamRequest({
    this.name,
    this.playerIds,
  });

  factory UpdateTeamRequest.fromParams(UpdateTeamParams params) =>
      UpdateTeamRequest(
        name: params.name,
        playerIds: params.playerIds,
      );

  Map<String, dynamic> toJson() => _$UpdateTeamRequestToJson(this);
}
