
import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/domain/entities/team_player.dart';

part 'team_player_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TeamPlayerModel {
  final String teamId;
  final String playerId;
  final int? number;
  final String firstName;
  final String lastName;
  final String? photoUrl;

  const TeamPlayerModel({
    required this.teamId,
    required this.playerId,
    this.number,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
  });

  factory TeamPlayerModel.fromJson(Map<String, dynamic> json) => _$TeamPlayerModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamPlayerModelToJson(this);

  TeamPlayer toEntity() {
    return TeamPlayer(
      teamId: teamId,
      playerId: playerId,
      number: number,
      firstName: firstName,
      lastName: lastName,
      photoUrl: photoUrl,
    );
  }
}