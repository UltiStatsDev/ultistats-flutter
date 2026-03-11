import 'package:ultistats/core/domain/params/pagination_params.dart';

class TeamFilterParams extends PaginationParams {
  final String? name;

  const TeamFilterParams({
    super.page,
    super.size,
    super.sort,
    this.name,
  });
}
