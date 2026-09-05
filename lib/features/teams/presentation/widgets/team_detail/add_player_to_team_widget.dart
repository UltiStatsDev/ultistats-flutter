import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/features/players/domain/entities/player_list_item.dart';
import 'package:ultistats/features/players/presentation/providers/player_search_provider.dart';

class AddPlayerToTeamWidget extends ConsumerStatefulWidget {
  const AddPlayerToTeamWidget({
    super.key,
    required this.onPlayerSelected,
    this.isProcessing = false,
    this.existingPlayerIds = const {},
  });

  final Function(PlayerListItem) onPlayerSelected;
  final bool isProcessing;
  final Set<String> existingPlayerIds;

  @override
  ConsumerState<AddPlayerToTeamWidget> createState() =>
      _AddPlayerToTeamWidgetState();
}

class _AddPlayerToTeamWidgetState extends ConsumerState<AddPlayerToTeamWidget> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isProcessing) {
      return Container(
        height: 60,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: !_isSearching ? _buildAddButton(theme) : _buildSearchField(theme),
    );
  }

  Widget _buildAddButton(ThemeData theme) {
    return InkWell(
      onTap: () => setState(() => _isSearching = true),
      borderRadius: BorderRadius.circular(theme.cardBorderRadius),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(theme.cardBorderRadius),
        ),
        child: Icon(
          Icons.add,
          color: theme.colorScheme.primaryContainer,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return Autocomplete<PlayerListItem>(
      displayStringForOption: (player) =>
          '${player.firstName} ${player.lastName}',
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.length < 2) return const Iterable.empty();
        final results = await ref.read(
          playerSearchProvider(textEditingValue.text).future,
        );
        
        // Фильтруем игроков, которые уже есть в команде
        return results.where((p) => !widget.existingPlayerIds.contains(p.id));
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: theme.textFieldHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(theme.textFieldBorderRadius),
            boxShadow: theme.cardBoxShadow,
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            style: theme.textFieldStyleText,
            decoration: InputDecoration(
              hintText: "Поиск игрока...",
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.close,
                  color: theme.primaryColor.withValues(alpha: 0.5),
                  size: 22,
                ),
                onPressed: () => setState(() => _isSearching = false),
              ),
            ),
          ),
        );
      },
      onSelected: (player) {
        widget.onPlayerSelected(player);
        setState(() => _isSearching = false);
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(theme.cardBorderRadius),
            color: theme.colorScheme.primaryContainer,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 200,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final player = options.elementAt(index);
                  return ListTile(
                    title: Text(
                      '${player.firstName} ${player.lastName}',
                      style: theme.textTheme.labelMedium,
                    ),
                    onTap: () => onSelected(player),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
