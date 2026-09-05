import 'package:flutter/material.dart';

class TeamDetailAppBar extends StatelessWidget {
  const TeamDetailAppBar({super.key, this.onBackPressed});

  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(onPressed: onBackPressed, icon: Icon(Icons.arrow_back)),
      ],
    );
  }
}
