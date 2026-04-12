import 'package:ultistats/features/teams/domain/entities/team_list_item.dart';

class PlayerDetail {
  final String id;
  final TeamListItem? team;
  final int? number;
  final String firstName;
  final String lastName;
  final String? photoUrl;

  const PlayerDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.team,
    this.number,
    this.photoUrl,
  });
}
