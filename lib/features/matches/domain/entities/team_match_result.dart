class TeamMatchResult {
  final String id;
  final String name;
  final int score;
  final List<String> playerIds;
  final String? city;
  final String? photoUrl;

  const TeamMatchResult({
    required this.id,
    required this.name,
    required this.score,
    required this.playerIds,
    this.city,
    this.photoUrl,
  });
}
