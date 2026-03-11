import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/teams/domain/params/create_team_params.dart';

part 'create_team_request.g.dart';

@JsonSerializable()
class CreateTeamRequest {
  final String name;
  final List<String> playerIds;

  const CreateTeamRequest({
    required this.name,
    required this.playerIds,
  });

  factory CreateTeamRequest.fromParams(CreateTeamParams params) =>
      CreateTeamRequest(
        name: params.name,
        playerIds: params.playerIds,
      );

  Map<String, dynamic> toJson() => _$CreateTeamRequestToJson(this);
}
