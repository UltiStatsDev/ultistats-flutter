import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MatchesListScreen extends StatelessWidget {
  const MatchesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("matchesList"),
    );
  }
}
