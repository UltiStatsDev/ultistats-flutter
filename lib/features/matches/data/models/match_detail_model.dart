import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/data/models/team_match_result_model.dart';
import 'package:ultistats/features/matches/domain/entities/match_detail.dart';

part 'match_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MatchDetailModel {
  final String id;
  final List<TeamMatchResultModel> teams;
  final int eventCount;
  final String? diskHolderId;
  final DateTime? plannedStartTimestamp;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String status;

  const MatchDetailModel({
    required this.id,
    required this.teams,
    required this.eventCount,
    required this.status,
    this.diskHolderId,
    this.plannedStartTimestamp,
    this.startedAt,
    this.endedAt,
  });

  factory MatchDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MatchDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchDetailModelToJson(this);

  factory MatchDetailModel.fromEntity(MatchDetail entity) {
    return MatchDetailModel(
      id: entity.id,
      teams: entity.teams.map((t) => TeamMatchResultModel.fromEntity(t)).toList(),
      eventCount: entity.eventCount,
      diskHolderId: entity.diskHolderId,
      plannedStartTimestamp: entity.plannedStartTimestamp,
      startedAt: entity.startedAt,
      endedAt: entity.endedAt,
      status: entity.status.name,
    );
  }

  MatchDetail toEntity() {
    return MatchDetail(
      id: id,
      teams: teams.map((t) => t.toEntity()).toList(),
      eventCount: eventCount,
      diskHolderId: diskHolderId,
      plannedStartTimestamp: plannedStartTimestamp,
      startedAt: startedAt,
      endedAt: endedAt,
      status: _parseStatus(status),
    );
  }

  static MatchStatus _parseStatus(String status) {
    return switch (status.toUpperCase()) {
      'PLANNED' => MatchStatus.planned,
      'IN_PROGRESS' => MatchStatus.inProgress,
      'FINISHED' => MatchStatus.finished,
      _ => MatchStatus.planned,
    };
  }
}
