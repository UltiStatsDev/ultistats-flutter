import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/widgets/error_screen.dart';
import 'package:ultistats/core/widgets/screen_wrapper.dart';
import 'package:ultistats/features/players/presentation/providers/player_detail_notifier.dart';
import 'package:ultistats/features/players/presentation/providers/player_detail_state.dart';
import 'package:ultistats/features/players/presentation/widgets/player_detail/loading_player_detail_widget.dart';
import 'package:ultistats/features/players/presentation/widgets/player_detail/player_detail_widget.dart';


@RoutePage()
class PlayerDetailScreen extends ConsumerWidget {
  const PlayerDetailScreen({super.key, required this.playerId});

  final String playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playerDetailProvider(playerId));

    return ScreenWrapper(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 200),
        child: switch (state) {
          PlayerDetailInitial() || PlayerDetailLoading() =>
            const LoadingPlayerDetailWidget(key: ValueKey("loading")),
          PlayerDetailLoaded(:final player) => PlayerDetailWidget(
            key: ValueKey("loaded"),
            player: player,
          ),
          PlayerDetailError(:final error, :final stackTrace) => ErrorScreen(
            exception: error,
            stackTrace: stackTrace,
            key: ValueKey("error"),
            onRetry: () {
              ref.read(playerDetailProvider(playerId).notifier).refresh();
            },
          ),
        },
      ),
    );
  }
}
