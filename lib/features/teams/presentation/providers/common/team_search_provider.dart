import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/logging/app_logger.dart';
import 'package:ultistats/features/teams/domain/entities/team_list_item.dart';
import 'package:ultistats/features/teams/domain/params/team_filter_params.dart';

final teamSearchProvider = FutureProvider.family<List<TeamListItem>, String>((
  ref,
  query,
) async {
  if (query.length < 2) return [];

  log(
    'Searching teams by "$query"',
    name: 'TeamSearchProvider',
    level: AppLogLevel.debug,
  );

  final repository = ref.read(teamsRepositoryProvider);
  try {
    final result = await repository.getList(
      TeamFilterParams(name: query, size: 10),
    );

    log(
      'Found ${result.content.length} teams for "$query"',
      name: 'TeamSearchProvider',
      level: AppLogLevel.debug,
    );

    return result.content;
  } catch (e, st) {
    log(
      'Error while searching teams by "$query"',
      error: e,
      stackTrace: st,
      name: 'TeamSearchProvider',
    );
    rethrow;
  }
});
