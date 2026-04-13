import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_themes.dart';

// TODO какойто кал со стеком мб посмотреть как сделать получше
class CreatePlayerAppBar extends StatelessWidget {
  const CreatePlayerAppBar({super.key, this.onBackPressed});

  final VoidCallback? onBackPressed;

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
            child: Text('Создать игрока', style: theme.textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
