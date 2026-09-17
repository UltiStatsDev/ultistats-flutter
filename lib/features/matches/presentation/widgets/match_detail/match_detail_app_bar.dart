import 'package:flutter/material.dart';

class MatchDetailAppBar extends StatelessWidget {
  const MatchDetailAppBar({
    super.key,
    this.onBackPressed,
    this.onEditPressed,
  });

  final VoidCallback? onBackPressed;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBackPressed,
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        const Spacer(),
        if (onEditPressed != null)
          IconButton(
            onPressed: onEditPressed,
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
      ],
    );
  }
}
