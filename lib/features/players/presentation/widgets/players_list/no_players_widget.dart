import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/players/presentation/providers/players_list_notifier.dart';
import 'package:ultistats/features/players/presentation/screens/edit_player_screen.dart';
import 'package:ultistats/router/app_router.gr.dart';

class NoPlayersWidget extends ConsumerWidget {
  const NoPlayersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Нет игроков', style: theme.textTheme.displayLarge),
              SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(playersListProvider.notifier).loadInitial(),
                label: Text("Перезагрузить"),
                icon: Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        Positioned(
          right: 19 - theme.screenPadding,
          bottom: 24,
          child: FloatingActionButton(
            onPressed: () {
              context.router.push(
                EditPlayerRoute(
                  title: "Создание игрока",
                  confirmButtonText: "Создать игрока",
                  editScreenInitial: EditScreenInitial(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
