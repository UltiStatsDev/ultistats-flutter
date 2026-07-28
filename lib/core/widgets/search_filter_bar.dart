import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';
import 'package:ultistats/core/widgets/app_ink_well.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    super.key,
    this.onChanged,
  });

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Container(
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
          ),
        ),
        // SizedBox(width: 8),
        // _SearchButton(icon: Icons.search, onPressed: () {}),
        // SizedBox(width: 8),
        // _SearchButton(icon: Icons.filter_alt_outlined, onPressed: () {}),
      ],
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({required this.onPressed, required this.icon});

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppInkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(theme.searchBarBorderRadius),
      child: Ink(
        width: theme.searchBarSize,
        height: theme.searchBarSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.searchBarBorderRadius),
          color: theme.colorScheme.primaryContainer,
        ),
        child: Icon(icon, color: theme.primaryColor, size: 30),
      ),
    );
  }
}
