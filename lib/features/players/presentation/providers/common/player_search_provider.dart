import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/di.dart';
import 'package:ultistats/core/logging/app_logger.dart';
import 'package:ultistats/features/players/domain/entities/player_list_item.dart';
import 'package:ultistats/features/players/domain/params/player_filter_params.dart';

final playerSearchProvider =
    FutureProvider.family<List<PlayerListItem>, String>((ref, query) async {
      if (query.length < 2) return [];

      log(
        'Searching players by "$query"',
        name: 'PlayerSearchProvider',
        level: AppLogLevel.debug,
      );

      final repository = ref.read(playersRepositoryProvider);
      try {
        final result = await repository.getList(
          PlayerFilterParams(name: query, size: 10),
        );

        log(
          'Found ${result.content.length} players for "$query"',
          name: 'PlayerSearchProvider',
          level: AppLogLevel.debug,
        );

        return result.content;
      } catch (e, st) {
        log(
          'Error while searching players by "$query"',
          error: e,
          stackTrace: st,
          name: 'PlayerSearchProvider',
        );
        rethrow;
      }
    });
