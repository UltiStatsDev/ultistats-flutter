import 'package:ultistats/core/params/pagination_params.dart';

class TeamFilterParams extends PaginationParams {
  final String? name;

  const TeamFilterParams({
    this.name,
  });
}