import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/teams/domain/entities/team_list_item.dart';
import 'package:ultistats/features/teams/presentation/providers/common/team_search_provider.dart';

class TeamSelectorTile extends ConsumerWidget {
  const TeamSelectorTile({
    super.key,
    required this.onTeamSelected,
    this.initialTeam,
    required this.label,
    this.excludedIds = const {},
  });

  final String label;
  final Function(TeamListItem?) onTeamSelected;
  final TeamListItem? initialTeam;
  final Set<String> excludedIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.displayMedium),
        const SizedBox(height: 4),
        if (initialTeam != null)
          _SelectedTeamCard(
            team: initialTeam!,
            onClear: () => onTeamSelected(null),
          )
        else
          _TeamSearchField(
            theme: theme,
            ref: ref,
            excludedIds: excludedIds,
            onTeamSelected: onTeamSelected,
          ),
      ],
    );
  }
}

class _SelectedTeamCard extends StatelessWidget {
  const _SelectedTeamCard({required this.team, required this.onClear});

  final TeamListItem team;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: theme.textFieldHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(theme.textFieldBorderRadius),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: theme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              team.name,
              style: theme.textFieldStyleText,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.close, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            color: theme.primaryColor.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}

class _TeamSearchField extends StatelessWidget {
  const _TeamSearchField({
    required this.theme,
    required this.ref,
    required this.excludedIds,
    required this.onTeamSelected,
  });

  final ThemeData theme;
  final WidgetRef ref;
  final Set<String> excludedIds;
  final Function(TeamListItem?) onTeamSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<TeamListItem>(
          displayStringForOption: (team) => team.name,
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.length < 2) {
              return const Iterable<TeamListItem>.empty();
            }

            try {
              final results = await ref.read(
                teamSearchProvider(textEditingValue.text).future,
              );
              return results.where((team) => !excludedIds.contains(team.id));
            } catch (e) {
              return const Iterable<TeamListItem>.empty();
            }
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: theme.textFieldHeight,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(theme.textFieldBorderRadius),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                style: theme.textFieldStyleText,
                decoration: const InputDecoration(
                  hintText: "Начните вводить название...",
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(theme.cardBorderRadius),
                child: Container(
                  width: constraints.maxWidth,
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final team = options.elementAt(index);
                      return ListTile(
                        dense: true,
                        title: Text(team.name, style: theme.textTheme.labelMedium),
                        subtitle: team.city != null
                            ? Text(team.city!, style: theme.textTheme.labelSmall)
                            : null,
                        onTap: () => onSelected(team),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          onSelected: onTeamSelected,
        );
      },
    );
  }
}
