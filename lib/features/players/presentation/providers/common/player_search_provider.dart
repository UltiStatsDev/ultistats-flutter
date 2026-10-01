import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/features/players/domain/entities/player_list_item.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';

final playerSearchProvider = FutureProvider.family<List<PlayerListItem>, String>((ref, query) async {
  if (query.length < 2) return [];
  
  final repository = ref.read(playersRepositoryProvider);
  final result = await repository.getList(
    PlayerFilterParams(name: query, size: 10),
  );
  
  return result.content;
});
