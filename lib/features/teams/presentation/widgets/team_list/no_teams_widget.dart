import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/teams/presentation/providers/team_list/teams_list_notifier.dart';
import 'package:ultistats/features/teams/presentation/screens/edit_team_screen.dart';
import 'package:ultistats/router/app_router.gr.dart';

class NoTeamsWidget extends ConsumerWidget {
  const NoTeamsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Нет команд', style: theme.textTheme.displayLarge),
              SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(teamsListProvider.notifier).loadInitial(),
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
                EditTeamRoute(
                  title: "Создание команды",
                  confirmButtonText: "Создать команду",
                  initialData: EditTeamScreenInitial(),
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
