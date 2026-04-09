import 'package:ultistats/features/players/domain/entities/player.dart';

class Team {
  final String id;
  final String name;
  final List<Player> players;
  final String? city;
  final String? photoUrl;

  const Team({
    required this.id,
    required this.name,
    required this.players,
    this.city,
    this.photoUrl,
  });

  const Team.placeholder()
    : id = "0",
      name = "Team Name",
      players = const [],
      city = "Novosibirsk",
      photoUrl = null;
}
