import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/teams/data/models/team_model.dart';
import 'package:ultistats/features/matches/domain/entities/match.dart';

part 'match_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MatchModel {
  final String id;
  final List<TeamModel> teams;
  final int eventCount;
  final String? diskHolderId;

  const MatchModel({
    required this.id,
    required this.teams,
    required this.eventCount,
    this.diskHolderId,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchModelToJson(this);

  factory MatchModel.fromEntity(Match entity) {
    return MatchModel(
      id: entity.id,
      teams: entity.teams.map((t) => TeamModel.fromEntity(t)).toList(),
      eventCount: entity.eventCount,
      diskHolderId: entity.diskHolderId,
    );
  }

  Match toEntity() {
    return Match(
      id: id,
      teams: teams.map((t) => t.toEntity()).toList(),
      eventCount: eventCount,
      diskHolderId: diskHolderId,
    );
  }
}
