import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';

class MatchPreparationAppBar extends StatelessWidget {
  const MatchPreparationAppBar({super.key, this.onBackPressed, required this.title});

  final VoidCallback? onBackPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: theme.appBarHeight,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBackPressed,
              icon: Icon(Icons.arrow_back),
            ),
          ),
          Center(
            child: Text(title, style: theme.textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
