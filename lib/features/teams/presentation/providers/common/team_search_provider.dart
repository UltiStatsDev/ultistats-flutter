import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/teams/domain/entities/team_list_item.dart';
import 'package:ultistats/features/teams/domain/params/team_filter_params.dart';

final teamSearchProvider = FutureProvider.family<List<TeamListItem>, String>((ref, query) async {
  if (query.length < 2) return [];

  final repository = ref.read(teamsRepositoryProvider);
  final result = await repository.getList(
    TeamFilterParams(name: query, size: 10),
  );

  return result.content;
});

