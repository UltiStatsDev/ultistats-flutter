import 'package:ultistats/features/players/domain/entities/player_list_item.dart';

class TeamDetail {
  final String id;
  final String name;
  final List<PlayerListItem> players;
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
