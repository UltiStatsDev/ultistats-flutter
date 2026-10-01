import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';

part 'create_player_request.g.dart';

@JsonSerializable(includeIfNull: false)
class CreatePlayerRequest {
  final String firstName;
  final String lastName;

  const CreatePlayerRequest({
    required this.firstName,
    required this.lastName,
  });

  factory CreatePlayerRequest.fromParams(CreatePlayerParams params) =>
      CreatePlayerRequest(
        firstName: params.firstName,
        lastName: params.lastName,
      );

  Map<String, dynamic> toJson() => _$CreatePlayerRequestToJson(this);
}
