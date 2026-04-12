import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/domain/entities/player_detail.dart';
import 'package:ultistats/features/teams/data/models/team_list_item_model.dart';

part 'player_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerDetailModel {
  final String id;
  final TeamListItemModel? team;
  final int? number;
  final String firstName;
  final String lastName;
  final String? photoUrl;

  const PlayerDetailModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.team,
    this.number,
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
      team: team?.toEntity(),
      number: number,
      photoUrl: photoUrl,
    );
  }
}
