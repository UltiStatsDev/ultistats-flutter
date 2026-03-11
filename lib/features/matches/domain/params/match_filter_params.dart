import 'package:ultistats/core/domain/params/pagination_params.dart';

class MatchFilterParams extends PaginationParams {
  final String? teamId;
  final String? status;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const MatchFilterParams({
    super.page,
    super.size,
    super.sort,
    this.teamId,
    this.status,
    this.dateFrom,
    this.dateTo,
  });
}
