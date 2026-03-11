import 'package:ultistats/core/domain/params/pagination_params.dart';

class PlayerFilterParams extends PaginationParams {
  final String? teamId;
  final String? name;

  const PlayerFilterParams({
    super.page,
    super.size,
    super.sort,
    this.teamId,
    this.name,
  });
}
