import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/domain/params/create_player_params.dart';

part 'create_player_request.g.dart';

@JsonSerializable()
class CreatePlayerRequest {
  final int number;
  final String firstName;
  final String lastName;
  final String teamId;

  const CreatePlayerRequest({
    required this.number,
    required this.firstName,
    required this.lastName,
    required this.teamId,
  });

  factory CreatePlayerRequest.fromParams(CreatePlayerParams params) =>
      CreatePlayerRequest(
        number: params.number,
        firstName: params.firstName,
        lastName: params.lastName,
        teamId: params.teamId,
      );

  Map<String, dynamic> toJson() => _$CreatePlayerRequestToJson(this);
}
