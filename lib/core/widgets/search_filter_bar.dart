import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: theme.searchBarSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(theme.searchBarBorderRadius),
      ),
      child: TextField(
        onChanged: onChanged,
        style: theme.textFieldStyleText,
        decoration: const InputDecoration(hintText: "Поиск..."),
      ),
    );
  }
}
