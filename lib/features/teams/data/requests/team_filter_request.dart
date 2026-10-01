import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/teams/domain/params/team_filter_params.dart';

part 'team_filter_request.g.dart';

@JsonSerializable(includeIfNull: false)
class TeamFilterRequest {
  final int page;
  final int size;
  final String? sort;
  final String? name;

  const TeamFilterRequest({
    required this.page,
    required this.size,
    this.sort,
    this.name,
  });

  factory TeamFilterRequest.fromParams(TeamFilterParams params) =>
      TeamFilterRequest(
        page: params.page,
        size: params.size,
        sort: params.sort,
        name: params.name,
      );

  Map<String, dynamic> toJson() => _$TeamFilterRequestToJson(this);
}
