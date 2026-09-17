import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/data/models/match_team_model.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';

part 'match_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MatchDetailModel {
  final String id;
  final List<MatchTeamModel> teams;
  final int eventCount;
  final DateTime? plannedStartTimestamp;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String status;

  const MatchDetailModel({
    required this.id,
    required this.teams,
    required this.eventCount,
    required this.status,
    this.plannedStartTimestamp,
    this.startedAt,
    this.endedAt,
  });

  factory MatchDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MatchDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchDetailModelToJson(this);

  MatchDetail toEntity() {
    return MatchDetail(
      id: id,
      teams: teams.map((t) => t.toEntity()).toList(),
      eventCount: eventCount,
      plannedStartTimestamp: plannedStartTimestamp,
      startedAt: startedAt,
      endedAt: endedAt,
      status: MatchStatus.parse(status),
    );
  }
}
