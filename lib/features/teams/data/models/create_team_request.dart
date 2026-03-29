import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/teams/domain/params/create_team_params.dart';

part 'create_team_request.g.dart';

@JsonSerializable(includeIfNull: false)
class CreateTeamRequest {
  final String name;
  final List<String> playerIds;
  final String? city;

  const CreateTeamRequest({
    required this.name,
    required this.playerIds,
    this.city,
  });

  factory CreateTeamRequest.fromParams(CreateTeamParams params) =>
      CreateTeamRequest(
        name: params.name,
        playerIds: params.playerIds,
        city: params.city,
      );

  Map<String, dynamic> toJson() => _$CreateTeamRequestToJson(this);
}
