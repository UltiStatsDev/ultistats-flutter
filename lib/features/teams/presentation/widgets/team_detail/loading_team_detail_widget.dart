import 'package:flutter/material.dart';

class LoadingTeamDetailWidget extends StatelessWidget {
  const LoadingTeamDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
