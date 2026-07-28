import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/domain/params/update_player_params.dart';

part 'update_player_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdatePlayerRequest {
  final String? firstName;
  final String? lastName;

  const UpdatePlayerRequest({
    this.firstName,
    this.lastName,
  });

  factory UpdatePlayerRequest.fromParams(UpdatePlayerParams params) =>
      UpdatePlayerRequest(
        firstName: params.firstName,
        lastName: params.lastName,
      );

  Map<String, dynamic> toJson() => _$UpdatePlayerRequestToJson(this);
}
