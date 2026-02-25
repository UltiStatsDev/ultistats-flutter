import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/data/models/player_model.dart';
import 'package:ultistats/features/teams/domain/entities/team.dart';

part 'team_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TeamModel {
  final String id;
  final String name;
  final List<PlayerModel> players;

  const TeamModel({
    required this.id,
    required this.name,
    required this.players,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamModelToJson(this);

  factory TeamModel.fromEntity(Team entity) {
    return TeamModel(
      id: entity.id,
      name: entity.name,
      players: entity.players.map((p) => PlayerModel.fromEntity(p)).toList(),
    );
  }

  Team toEntity() {
    return Team(
      id: id,
      name: name,
      players: players.map((p) => p.toEntity()).toList(),
    );
  }
}
