import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/teams/domain/entities/team_list_item.dart';
import 'package:ultistats/features/teams/presentation/providers/team_search_provider.dart';

class TeamSelectorTile extends ConsumerWidget {
  const TeamSelectorTile({
    super.key,
    required this.onTeamSelected,
    this.initialTeam,
  });

  final Function(TeamListItem?) onTeamSelected;
  final TeamListItem? initialTeam;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Команда:", style: theme.textTheme.displayMedium),
        const SizedBox(height: 4),
        LayoutBuilder(
          builder: (context, constraints) {
            return Autocomplete<TeamListItem>(
              displayStringForOption: (team) => team.name,
              initialValue: TextEditingValue(text: initialTeam?.name ?? ''),
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<TeamListItem>.empty();
                }

                return await ref.read(
                  teamSearchProvider(textEditingValue.text).future,
                );
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: theme.textFieldHeight,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(
                      theme.textFieldBorderRadius,
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style: theme.textFieldStyleText,
                    decoration: const InputDecoration(
                      hintText: "Поиск команды",
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        onTeamSelected(null);
                      }
                    },
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
                            title: Text(
                              team.name,
                              style: theme.textTheme.labelMedium,
                            ),
                            subtitle: team.city != null
                                ? Text(
                                  team.city!,
                                  style: theme.textTheme.labelSmall,
                                )
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
        ),
      ],
    );
  }
}
