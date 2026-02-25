import 'package:ultistats/features/players/domain/entities/player.dart';

class Team {
  final String id;
  final String name;
  final List<Player> players;

  const Team({required this.id, required this.name, required this.players});
}
