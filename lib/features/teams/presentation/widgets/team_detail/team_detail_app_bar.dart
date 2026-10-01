import 'package:flutter/material.dart';

class TeamDetailAppBar extends StatelessWidget {
  const TeamDetailAppBar({super.key, this.onBackPressed, this.onEditPressed});

  final VoidCallback? onBackPressed;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onBackPressed, icon: Icon(Icons.arrow_back)),
        Spacer(),
        IconButton(onPressed: onEditPressed, icon: Icon(Icons.edit)),
      ],
    );
  }
}
