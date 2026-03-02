import 'package:ultistats/core/params/pagination_params.dart';

class PlayerFilterParams extends PaginationParams {
  final String? teamId;
  final String? name;

  const PlayerFilterParams({
    this.teamId,
    this.name,
  });
}