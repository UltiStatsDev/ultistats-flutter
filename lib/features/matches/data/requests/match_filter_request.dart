import 'package:json_annotation/json_annotation.dart';
import 'package:ultistats/features/matches/domain/params/match_filter_params.dart';

part 'match_filter_request.g.dart';

@JsonSerializable(includeIfNull: false)
class MatchFilterRequest {
  final int page;
  final int size;
  final String? sort;
  final String? teamId;
  final String? status;
  final String? dateFrom;
  final String? dateTo;

  const MatchFilterRequest({
    required this.page,
    required this.size,
    this.sort,
    this.teamId,
    this.status,
    this.dateFrom,
    this.dateTo,
  });

  factory MatchFilterRequest.fromParams(MatchFilterParams params) =>
      MatchFilterRequest(
        page: params.page,
        size: params.size,
        sort: params.sort,
        teamId: params.teamId,
        status: params.status,
        dateFrom: params.dateFrom?.toIso8601String(),
        dateTo: params.dateTo?.toIso8601String(),
      );

  Map<String, dynamic> toJson() => _$MatchFilterRequestToJson(this);
}
