import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';

part 'update_player_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdatePlayerRequest {
  final int? number;
  final String? firstName;
  final String? lastName;
  final String? teamId;

  const UpdatePlayerRequest({
    this.number,
    this.firstName,
    this.lastName,
    this.teamId,
  });

  factory UpdatePlayerRequest.fromParams(UpdatePlayerParams params) =>
      UpdatePlayerRequest(
        number: params.number,
        firstName: params.firstName,
        lastName: params.lastName,
        teamId: params.teamId,
      );

  Map<String, dynamic> toJson() => _$UpdatePlayerRequestToJson(this);
}
