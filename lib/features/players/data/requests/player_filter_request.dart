import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';

part 'player_filter_request.g.dart';

@JsonSerializable(includeIfNull: false)
class PlayerFilterRequest {
  final int page;
  final int size;
  final String? sort;
  final String? name;
  final String? teamId;

  const PlayerFilterRequest({
    required this.page,
    required this.size,
    this.sort,
    this.name,
    this.teamId,
  });

  factory PlayerFilterRequest.fromParams(PlayerFilterParams params) =>
      PlayerFilterRequest(
        page: params.page,
        size: params.size,
        sort: params.sort,
        name: params.name,
        teamId: params.teamId,
      );

  Map<String, dynamic> toJson() => _$PlayerFilterRequestToJson(this);
}
