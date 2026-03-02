import 'package:ultistats/core/params/pagination_params.dart';

class MatchFilterParams extends PaginationParams {
  final String? teamId;
  final String? status;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const MatchFilterParams({
    this.teamId,
    this.status,
    this.dateFrom,
    this.dateTo,
  });
}