import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/params/update_match_params.dart';

part 'update_match_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateMatchRequest {
  final List<String>? teamIds;
  final String? plannedStartTimestamp;

  const UpdateMatchRequest({
    this.teamIds,
    this.plannedStartTimestamp,
  });

  factory UpdateMatchRequest.fromParams(UpdateMatchParams params) =>
      UpdateMatchRequest(
        teamIds: params.teamIds,
        plannedStartTimestamp: params.plannedStartTimestamp?.toUtc().toIso8601String(),
      );

  Map<String, dynamic> toJson() => _$UpdateMatchRequestToJson(this);
}
