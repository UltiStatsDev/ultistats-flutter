import 'package:json_annotation/json_annotation.dart';

part 'upsert_team_player_request.g.dart';

@JsonSerializable()
class UpsertTeamPlayerRequest {
  final int? number;

  const UpsertTeamPlayerRequest({
    this.number,
  });

  factory UpsertTeamPlayerRequest.fromJson(Map<String, dynamic> json) =>
      _$UpsertTeamPlayerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpsertTeamPlayerRequestToJson(this);
}
