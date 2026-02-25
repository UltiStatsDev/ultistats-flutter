import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/domain/entities/player.dart';

part 'player_model.g.dart';

@JsonSerializable()
class PlayerModel {
  final String id;
  final String? teamId;  final int? number;
  final String firstName;
  final String lastName;

  const PlayerModel({
    required this.id,
    this.teamId,
    this.number,
    required this.firstName,
    required this.lastName,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) => _$PlayerModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerModelToJson(this);

  factory PlayerModel.fromEntity(Player entity) {
    return PlayerModel(
      id: entity.id,
      teamId: entity.teamId,
      number: entity.number,
      firstName: entity.firstName,
      lastName: entity.lastName,
    );
  }

  Player toEntity() {
    return Player(
      id: id,
      teamId: teamId,
      number: number,
      firstName: firstName,
      lastName: lastName,
    );
  }
}