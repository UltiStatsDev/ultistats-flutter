import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/data/models/match_participant_model.dart';
import 'package:ultistats/features/matches/domain/entities/match_team.dart';

part 'match_team_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MatchTeamModel {
  final String teamId;
  final String teamName;
  final int teamScore;
  final List<MatchParticipantModel> participants;
  final String? city;
  final String? photoUrl;

  const MatchTeamModel({
    required this.teamId,
    required this.teamName,
    required this.teamScore,
    required this.participants,
    this.city,
    this.photoUrl,
  });

  factory MatchTeamModel.fromJson(Map<String, dynamic> json) =>
      _$MatchTeamModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchTeamModelToJson(this);

  MatchTeam toEntity() {
    return MatchTeam(
      id: teamId,
      name: teamName,
      score: teamScore,
      participants: participants.map((m) => m.toEntity()).toList(),
      city: city,
      photoUrl: photoUrl,
    );
  }
}
