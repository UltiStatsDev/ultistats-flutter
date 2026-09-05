import 'package:flutter/material.dart';

class LoadingPlayerDetailWidget extends StatelessWidget {
  const LoadingPlayerDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
