import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/matches/presentation/providers/matches_providers.dart';

class NoMatchesWidget extends ConsumerWidget {
  const NoMatchesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Нет матчей', style: theme.textTheme.displayLarge),
              SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(matchesListProvider.notifier).loadInitial(),
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
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
