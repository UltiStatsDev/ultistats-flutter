import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/teams/domain/params/update_team_params.dart';

part 'update_team_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateTeamRequest {
  final String? name;
  final String? city;

  const UpdateTeamRequest({
    this.name,
    this.city,
  });

  factory UpdateTeamRequest.fromParams(UpdateTeamParams params) =>
      UpdateTeamRequest(
        name: params.name,
        city: params.city,
      );

  Map<String, dynamic> toJson() => _$UpdateTeamRequestToJson(this);
}
