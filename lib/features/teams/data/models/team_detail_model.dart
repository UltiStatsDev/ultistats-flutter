import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/data/models/team_player_model.dart';
import 'package:ultistats/features/teams/domain/entities/team_detail.dart';

part 'team_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TeamDetailModel {
  final String id;
  final String name;
  final List<TeamPlayerModel> players;
  final String? city;
  final String? photoUrl;

  const TeamDetailModel({
    required this.id,
    required this.name,
    required this.players,
    this.city,
    this.photoUrl,
  });

  factory TeamDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TeamDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamDetailModelToJson(this);

  TeamDetail toEntity() {
    return TeamDetail(
      id: id,
      name: name,
      players: players.map((p) => p.toEntity()).toList(),
      city: city,
      photoUrl: photoUrl,
    );
  }
}
