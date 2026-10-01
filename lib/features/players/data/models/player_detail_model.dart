import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/data/models/player_membership_model.dart';
import 'package:ultistats/features/players/domain/entities/player_detail.dart';

part 'player_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerDetailModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final List<PlayerMembershipModel> memberships;

  const PlayerDetailModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.memberships,
    this.photoUrl,
  });

  factory PlayerDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerDetailModelToJson(this);

  PlayerDetail toEntity() {
    return PlayerDetail(
      id: id,
      firstName: firstName,
      lastName: lastName,
      photoUrl: photoUrl,
      memberships: memberships.map((m) => m.toEntity()).toList(),
    );
  }
}
