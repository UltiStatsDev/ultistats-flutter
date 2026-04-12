import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/entities/match.dart';
import 'package:ultistats/features/matches/domain/entities/match_list_item.dart';

part 'match_list_item_model.g.dart';

@JsonSerializable()
class MatchListItemModel {
  final String id;
  final List<MatchListTeamModel> teams;
  final DateTime? plannedStartTimestamp;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final MatchStatus status;

  const MatchListItemModel({
    required this.id,
    required this.teams,
    this.plannedStartTimestamp,
    this.startedAt,
    this.endedAt,
    required this.status,
  });

  factory MatchListItemModel.fromJson(Map<String, dynamic> json) =>
      _$MatchListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchListItemModelToJson(this);

  MatchListItem toEntity() {
    return MatchListItem(
      id: id,
      teams: teams.map((e) => e.toEntity()).toList(),
      plannedStartTimestamp: plannedStartTimestamp,
      startedAt: startedAt,
      endedAt: endedAt,
      status: status,
    );
  }
}

@JsonSerializable()
class MatchListTeamModel {
  final String teamId;
  final String teamName;
  final int teamScore;
  final List<String> playerIds;
  final String? city;
  final String? photoUrl;

  const MatchListTeamModel({
    required this.teamId,
    required this.teamName,
    required this.teamScore,
    required this.playerIds,
    this.city,
    this.photoUrl,
  });

  factory MatchListTeamModel.fromJson(Map<String, dynamic> json) =>
      _$MatchListTeamModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchListTeamModelToJson(this);

  MatchListTeam toEntity() {
    return MatchListTeam(
      teamId: teamId,
      teamName: teamName,
      teamScore: teamScore,
      city: city,
      photoUrl: photoUrl,
    );
  }
}
