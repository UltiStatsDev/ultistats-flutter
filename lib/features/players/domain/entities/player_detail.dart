import 'package:ultistats/features/players/domain/entities/player_membership.dart';

class PlayerDetail {
  final String id;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final List<PlayerMembership> memberships;

  const PlayerDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.memberships,
    this.photoUrl,
  });
}
