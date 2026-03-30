import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/team_match_result.dart';

part 'team_match_result_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TeamMatchResultModel {
  final String teamId;
  final String teamName;
  final int teamScore;
  final List<String> playerIds;
  final String? city;
  final String? photoUrl;

  const TeamMatchResultModel({
    required this.teamId,
    required this.teamName,
    required this.teamScore,
    required this.playerIds,
    this.city,
    this.photoUrl,
  });

  factory TeamMatchResultModel.fromJson(Map<String, dynamic> json) =>
      _$TeamMatchResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamMatchResultModelToJson(this);

  factory TeamMatchResultModel.fromEntity(TeamMatchResult entity) {
    return TeamMatchResultModel(
      teamId: entity.id,
      teamName: entity.name,
      teamScore: entity.score,
      playerIds: entity.playerIds,
      city: entity.city,
      photoUrl: entity.photoUrl,
    );
  }

  TeamMatchResult toEntity() {
    return TeamMatchResult(
      id: teamId,
      name: teamName,
      score: teamScore,
      playerIds: playerIds,
      city: city,
      photoUrl: photoUrl,
    );
  }
}
