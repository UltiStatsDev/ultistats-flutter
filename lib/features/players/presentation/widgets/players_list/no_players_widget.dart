import 'package:flutter/material.dart';

class NoPlayersWidget extends StatelessWidget {
  const NoPlayersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Игроки не найдены'),
    );
  }
}
