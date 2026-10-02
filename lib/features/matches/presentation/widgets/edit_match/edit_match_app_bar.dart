import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';

// TODO какойто кал со стеком мб посмотреть как сделать получше
class EditMatchAppBar extends StatelessWidget {
  const EditMatchAppBar(
      {super.key, this.onBackPressed, this.onDeletePressed, required this.title});

  final VoidCallback? onBackPressed;
  final VoidCallback? onDeletePressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: theme.appBarHeight,
      child: Stack(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBackPressed,
                icon: Icon(Icons.arrow_back),
              ),
              Spacer(),
              if (onDeletePressed != null)
                IconButton(
                  onPressed: onDeletePressed,
                  icon: Icon(Icons.delete),
                ),
            ],
          ),
          Center(
            child: Text(title, style: theme.textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
