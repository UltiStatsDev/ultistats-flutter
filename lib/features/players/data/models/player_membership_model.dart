import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/domain/entities/player_membership.dart';

part 'player_membership_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerMembershipModel {
  final String teamId;
  final String playerId;
  final int number;

  const PlayerMembershipModel({
    required this.teamId,
    required this.playerId,
    required this.number,
  });

  factory PlayerMembershipModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerMembershipModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerMembershipModelToJson(this);

  PlayerMembership toEntity() {
    return PlayerMembership(
      number: number,
      playerId: playerId,
      teamId: teamId,
    );
  }
}