class TeamPlayer {
  final String teamId;
  final String playerId;
  final int? number;
  final String firstName;
  final String lastName;
  final String? photoUrl;

  const TeamPlayer({
    required this.teamId,
    required this.playerId,
    this.number,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
  });
}