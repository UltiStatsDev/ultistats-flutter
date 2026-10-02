import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';

// TODO какойто кал со стеком мб посмотреть как сделать получше
class EditPlayerAppBar extends StatelessWidget {
  const EditPlayerAppBar(
      {super.key, this.onBackPressed, required this.title, this.onDeletePressed});

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
              IconButton(onPressed: onDeletePressed, icon: Icon(Icons.delete))
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
