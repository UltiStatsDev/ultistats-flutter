class UpdateTeamParams {
  final String teamId;
  final String? name;
  final List<String>? playerIds;
  final String? city;

  const UpdateTeamParams({
    required this.teamId,
    this.name,
    this.playerIds,
    this.city,
  });
}