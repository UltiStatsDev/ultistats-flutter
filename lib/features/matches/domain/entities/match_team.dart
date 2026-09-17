import 'package:ultistats/features/matches/domain/entities/match_participant.dart';
import 'package:ultistats/features/teams/domain/entities/team_list_item.dart';

class MatchTeam {
  final String id;
  final String name;
  final int score;
  final List<MatchParticipant> participants;
  final String? city;
  final String? photoUrl;

  const MatchTeam({
    required this.id,
    required this.name,
    required this.score,
    required this.participants,
    this.city,
    this.photoUrl,
  });

  TeamListItem toListItem() {
    return TeamListItem(
      id: id,
      name: name,
      city: city,
      photoUrl: photoUrl,
    );
  }
}
