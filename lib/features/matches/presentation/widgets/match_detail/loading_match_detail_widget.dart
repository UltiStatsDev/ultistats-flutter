import 'package:flutter/material.dart';

class LoadingMatchDetailWidget extends StatelessWidget {
  const LoadingMatchDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
