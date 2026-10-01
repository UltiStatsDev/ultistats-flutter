import 'package:ultistats/features/players/domain/entities/team_player.dart';

class TeamDetail {
  final String id;
  final String name;
  final List<TeamPlayer> players;
  final String? city;
  final String? photoUrl;

  const TeamDetail({
    required this.id,
    required this.name,
    required this.players,
    this.city,
    this.photoUrl,
  });
}
