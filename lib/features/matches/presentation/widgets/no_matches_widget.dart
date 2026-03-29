import 'package:flutter/material.dart';

class NoMatchesWidget extends StatelessWidget {
  const NoMatchesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Нет матчей',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
